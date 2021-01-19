defmodule FrontMatterTest do
  use ExUnit.Case
  doctest FrontMatter

  test "it can parse front matter" do
    string = """
    ---
    title: Hello
    tags: x, y, z
    ---
    Hello, world
    """

    {:ok, matter, body} = FrontMatter.parse(string)

    assert Kernel.map_size(matter) == 2
    assert matter["title"] == "Hello"
    assert matter["tags"] == ["x", "y", "z"]
    assert body == "Hello, world\n"
  end

  test "it can parse front matter when there's a `---` in the body" do
    string = """
    ---
    title: Hello
    tags: x, y, z
    ---
    Hello
    ---
    world
    """

    {:ok, matter, body} = FrontMatter.parse(string)

    assert Kernel.map_size(matter) == 2
    assert matter["title"] == "Hello"
    assert matter["tags"] == ["x", "y", "z"]
    assert body == "Hello\n---\nworld\n"
  end

  test "it fails safely if a yaml parse error is raised" do
    string = """
    ---
    hurrr:
    durrr
    ---
    Hello, world
    """

    {:error, _} = FrontMatter.parse(string)
  end

  test "it fails safely if there's no valid front matter" do
    string = """
    ---
    title: Hello
    --
    Hello, world
    """

    {:error, _} = FrontMatter.parse(string)
  end
end
