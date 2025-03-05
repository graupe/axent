# Axent

Axent contains some syntactic/grammatical extensions for Elixir. Opposed to
some other packages that provide similar functionality, this package actually
overrides core syntactic elements.

Axent is a personal experiment.

## Installation

Axent is [>available on github](https://github.com/graupe/axent) and can be installed
by adding `axent` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:axent, github: "graupe/axent"}
  ]
end
```

## Features

### Function definition (`def`) with top-level `with`

```elixir
defmodule SomeModule do
  use Axent
  def some_function(arg) do
    {:ok, value} <- external_function(arg)
    arg + value - silly_example
    v = more_function_calling(:arg, 3)
    {:ok, value} <- more_function(v)
  else
    {:error, reason} -> {:error, reason}
  end
end
```

### Struct definition (`defstruct`) with types

Define a struct and it's type in one go. This is similar to [Algae
defdata](https://hexdocs.pm/algae/Algae.html#defdata/1) but using
`defstruct` and none of the algebraic data type stuff (and less tested,
I suppose). Currently the struct type is always `t()` without any type
arguments.

```elixir
defmodule AStruct do
  use Axent
  defstruct do
    id :: non_neg_integer()
    name :: binary() | nil \\ nil
  end
end
```
