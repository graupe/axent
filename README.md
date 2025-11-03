# `Axent`

> [!WARNING]
>
> This is work in progress and likely not maintained. It is mostly untested in
> real projects. It's here, so I can test it in real projects.

[![Elixir CI](https://github.com/graupe/axent/actions/workflows/elixir.yml/badge.svg)](https://github.com/graupe/axent/actions/workflows/elixir.yml)

`Axent` contains some syntactic/grammatical extensions for Elixir. Opposed to
some other packages that provide similar functionality, this package actually
overrides core syntactic elements.

`Axent` is a personal experiment.

## Installation

`Axent` is [available on GitHub](https://github.com/graupe/axent) and can be installed
by adding `axent` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:axent, github: "graupe/axent", runtime: false}
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
    {:ok, value} <- more_function(value) \\ :morefu
    value
  else
    {:morefu, {:error, reason}} -> {}
    {:error, reason} -> {:error, reason}
  end
end
```

### Struct definition (`defstruct`) with types

Define a struct and its type in one go. This is similar to [Algae
`defdata`](https://hexdocs.pm/algae/Algae.html#defdata/1) but using
`defstruct` without the algebraic data type features. The struct type is
always `t()` without any type arguments.

Note that any field without a default value will be part of
`@enforce_keys`. Defaults are denoted by a `\\` at the end of a field definition.

```elixir
defmodule SomeStruct do
  use Axent
  defstruct do
    id :: non_neg_integer()
    name :: binary() | nil \\ nil
  end
end
```

## Special forms

These adaptations require that the AST (Abstract Syntax Tree) is rewritten
before being evaluated by the Elixir compiler, as they change the grammar of
`Kernel.SpecialForm` functions or macros.

This requires either wrapping the code with `use Axent do :some_code end` or
enabling `Axent` in the outer scope of the current block, so that native
language macros can be wrapped by `Axent` to perform the rewrite on the fly.
(Wrapped macros include `defmodule/2`, `defprotocol/2`, etc.)

### Short map

~Similar to other short map packages, but rewrites the standard syntax.
Variable pinning doesn't work in Elixir 1.8 and above.~
[es6_maps](https://github.com/kzemek/es6_maps) provides similar functionality
with a more invasive approach.

```elixir
use Axent do
  aaa = 1
  %{aaa: 1} = %{aaa}
  %{aaa} = %{aaa: 2}
  2 = aaa
  # variable pinning broken
  # %{^aaa} = %{aaa: ^aaa} = %{aaa: 1} = %{aaa}
end
```

Or for implicit use within a module:

```elixir
use Axent
defmodule SomeModule do
  # use short maps here
end
```
