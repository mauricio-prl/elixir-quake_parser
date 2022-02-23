# QuakeParser

A simple parser for the Quake 3 Arena game log.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `quake_parser` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:quake_parser, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/quake_parser](https://hexdocs.pm/quake_parser).

### Usage

Being in the project folder, start your elixir repl with `iex`:

```
iex -S mix
```

Then call `start` and `death_report` functions passing the filepath of the log:

```elixir
QuakeParser.start("path/to/log")
```

You should see an output like:

```elixir
[
  %QuakeParser.Game{
    kills: %{
      "Dono da Bola" => -1,
      "Isgalamido" => 1,
      "Mocinha" => 0,
      "Zeh" => -2
    },
    players: ["Dono da Bola", "Mocinha", "Isgalamido", "Zeh"],
    total_kills: 4
  }
]
```

```elixir
QuakeParser.death_report("path/to/log")
```

```elixir
%{0 => %{"MOD_FALLING" => 1, "MOD_ROCKET" => 1, "MOD_TRIGGER_HURT" => 2}}
```
