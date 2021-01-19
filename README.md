# FrontMatter

[![Hex.pm](https://img.shields.io/hexpm/dt/front_matter.svg)](https://hex.pm/packages/front_matter)
![build](https://github.com/Mdsp9070/front_matter/workflows/build/badge.svg?branch=main)

Parse a file or string containing front matter and a document body.
  
Front matter is a block of yaml wrapped between two lines containing `---`.
In this example, the front matter contains `title: Hello`, and the body is
`Hello, world`:

```md
---
title: Hello
---
Hello, world
```

After parsing the document, front matter is returned as a map, and the body as
a string.

```elixir
FrontMatter.parse_file "hello_world.md"
{:ok, %{"title" => "Hello"}, "Hello, world"}    
```

## Installation

Add `front_matter` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:front_matter, "~> 0.1.0"}]
end
```

Ensure `front_matter` is started before your application:

```elixir
def application do
  [applications: [:front_matter]]
end
```

## Usage

See [https://hexdocs.pm/front_matter/](https://hexdocs.pm/front_matter/)

## Testing

```bash
$ mix test
```

## Contributing

Pull requests are welcome!

## Credits

- [Matheus](https://github.com/Mdsp9070)

## License

The MIT License (MIT). Please check the [LICENSE](https://github.com/boostingtech/front_matter/blob/main/LICENSE.md) for more information.
