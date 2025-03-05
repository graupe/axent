# Axent

Axent contains some syntactic/grammatical extensions for Elixir. Opposed to some other packages that provide similar functionality, this package actually overrides core syntactic elements.

## Features

### Function definition (`def`) with top-level `with`

```elixir
def some_function(arg) do
  {:ok, value} <- external_function(arg)
  arg + value - silly_example
  v = more_function_calling(:arg, 3)
  {:ok, value} <- more_function(v)
else
  {:error, reason} -> {:error, reason}
end
```

### Struct definition (`defstruct`) with types

```elixir
defmodule AStruct do
  use Axent
  defstruct do
    id :: non_neg_integer()
    name :: binary() | nil \\ nil
  end
end
```

## Installation

Axent is available on [github](https://github.com/graupe/axent) and can be installed
by adding `axent` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:axent, github: "graupe/axent"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc).
