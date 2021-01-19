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
end
