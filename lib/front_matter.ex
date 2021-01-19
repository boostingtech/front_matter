defmodule FrontMatter do
  @moduledoc """
  Parse a file or string containing front matter and a document body.
  Front matter is a block of yaml wrapped between two lines containing `---`.

  In this example, the front matter contains `title: Hello` and `tags: x, y, z`, and the body is
  `Hello, world`:
  ```md
  ---
  title: Hello
  tags: x, y, z
  ---
  Hello, world
  ```

  After parsing the document, front matter is returned as a map, and the body as
  a string.
  ```elixir
  FrontMatter.parse_file "example.md"
  {:ok, %{"title" => "Hello", "tags" => ["x", "y", "z"]}, "Hello, world"}
  ```
  """

  @doc """
  Read a file, parse it's contents, and return it's front matter and body.
  Returns `{:ok, matter, body}` on success (`matter` is a map), or
  `{:error, error}` on error.
      iex> FrontMatter.parse_file "test/fixtures/dumb.md"
      {:ok, %{"title" => "Hello", "tags" => ["x", "y", "z"]}, "Hello, world\\n"}
      iex> FrontMatter.parse_file "test/fixtures/idontexist.md"
      {:error, :enoent}
  """
  def parse_file(path) do
    case File.read(path) do
      {:ok, contents} ->
        parse(contents)

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  Read a file, parse it's contents, and return it's front matter and body.
  Returns `{matter, body}` on success (`matter` is a map), throws on error.
      iex> FrontMatter.parse_file! "test/fixtures/dumb.md"
      {%{"title" => "Hello", "tags" => ["x", "y", "z"]}, "Hello, world\\n"}
      iex> try do
      ...>   FrontMatter.parse_file! "test/fixtures/idontexist.md"
      ...> rescue
      ...>   e in FrontMatter.Error -> e.message
      ...> end
      "File not found"
      iex> try do
      ...>   FrontMatter.parse_file! "test/fixtures/invalid.md"
      ...> rescue
      ...>   e in FrontMatter.Error -> e.message
      ...> end
      "Error parsing yaml front matter"
  """
  def parse_file!(path) do
    case parse_file(path) do
      {:ok, matter, body} ->
        {matter, body}

      {:error, :enoent} ->
        raise FrontMatter.Error, message: "File not found"

      {:error, _} ->
        raise FrontMatter.Error
    end
  end

  @doc """
  Parse a string and return it's front matter and body.
  Returns `{:ok, matter, body}` on success (`matter` is a map), or
  `{:error, error}` on error.
      iex> FrontMatter.parse "---\\ntitle: Hello\\n---\\nHello, world"
      {:ok, %{"title" => "Hello"}, "Hello, world"}
      iex> FrontMatter.parse "---\\ntitle: Hello\\n--\\nHello, world"
      {:error, :invalid_front_matter}
  """
  def parse(string) do
    string
    |> split_string()
    |> process_parts()
  end

  @doc """
  Parse a string and return it's front matter and body.
  Returns `{matter, body}` on success (`matter` is a map), throws on error.
      iex> FrontMatter.parse! "---\\ntitle: Hello\\n---\\nHello, world"
      {%{"title" => "Hello"}, "Hello, world"}
      iex> try do
      ...>   FrontMatter.parse! "---\\ntitle: Hello\\n--\\nHello, world"
      ...> rescue
      ...>   e in FrontMatter.Error -> e.message
      ...> end
      "Error parsing yaml front matter"
  """
  def parse!(string) do
    case parse(string) do
      {:ok, matter, body} ->
        {matter, body}

      {:error, _} ->
        raise FrontMatter.Error
    end
  end

  defp split_string(string) do
    split_pattern = ~r/[\s\r\n]---[\s\r\n]/s

    string
    |> (&String.trim_leading(&1)).()
    |> (&("\n" <> &1)).()
    |> split_by_regex(split_pattern, parts: 3)
  end

  defp split_by_regex(string, pattern, opts), do: Regex.split(pattern, string, opts)

  defp process_parts([_, yaml, body]) do
    case parse_yaml(yaml) do
      {:ok, yaml} ->
        {:ok, yaml, body}

      {:error, error} ->
        {:error, error}
    end
  end

  defp process_parts(_), do: {:error, :invalid_front_matter}

  defp parse_yaml(yaml) do
    case YamlElixir.read_from_string(yaml) do
      {:ok, parsed} ->
        {:ok, parsed |> transform()}

      error ->
        error
    end
  end

  defp parse_list({k, v}) do
    pattern = ~r/,/

    if v =~ pattern do
      v =
        v
        |> String.replace(" ", "")
        |> String.split(pattern)

      {k, v}
    else
      {k, v}
    end
  end

  defp transform(content) do
    content
    |> Task.async_stream(&parse_list/1)
    |> Enum.into(%{}, fn {:ok, {k, v}} -> {k, v} end)
  end
end
