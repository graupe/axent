# Axent

> [!WARNING]
>
> This is work in progress and likely not maintained. It is mostly untested in
> real projects. It's here, so I can test it in real projects.

Axent contains some syntactic/grammatical extensions for Elixir. Opposed to
some other packages that provide similar functionality, this package actually
overrides core syntactic elements.

Axent is a personal experiment.

## Installation

Axent is [available on GitHub](https://github.com/graupe/axent) and can be installed
by adding `axent` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:axent, github: "graupe/axent"}
  ]
end
```

<!--MODDOC_START-->

## Features

### Function definition (`def`)

Allow the use of `with`-style syntax on the top-level block of a function
definition.

```elixir
defmodule SomeModule do
  use Axent
  def some_function(arg) do
    {:ok, value} <- external_function(arg)
    arg =
        if value > 7 do
          value
        else
          333
        end
    v = more_function_calling(:arg, arg)
    {:ok, value} <- more_function(v)
    value
  else
    {:error, reason} -> {:error, reason}
  end
end
```

### Struct definition (`defstruct`) with types

Define a struct, and it's type in one go. This is similar to [Algae
defdata](https://hexdocs.pm/algae/Algae.html#defdata/1) but using
`defstruct` and none of the algebraic data type stuff. In addition, this code
is not tested thoroughly, yet. Also, the struct type is always `t()` without
any type
arguments.

Notable is, that any field, that doesn't have a default value, will be part of
`@enforce_keys`. Defaults are denoted by a `\\` at the end of a field definition.

```elixir
defmodule AStruct do
  use Axent
  defstruct do
    id :: non_neg_integer()
    name :: binary() | nil \\ nil
  end
end
```
