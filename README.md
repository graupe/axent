# `Excentrique`

> [!WARNING]
>
> This is work in progress and likely not maintained. It is mostly untested in
> real projects. It's here, so I can test it in real projects.

[![Elixir CI](https://github.com/graupe/excentrique/actions/workflows/elixir.yml/badge.svg)](https://github.com/graupe/excentrique/actions/workflows/elixir.yml)

`Excentrique` contains some syntactic/grammatical extensions for Elixir. Opposed to
other packages that provide some of these features, this package actually
overrides core syntactic elements to give cleaner feel and syntactic editor
support without special treatments.

`Excentrique` is a personal experiment.

## Installation

`Excentrique` is [available on GitHub](https://github.com/graupe/excentrique) and can be installed
by adding `axent` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:excentrique, github: "graupe/excentrique", runtime: false}
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
  use Excentrique
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

Define a struct, and it's type in one go. This is similar to [Algae
`defdata`](https://hexdocs.pm/algae/Algae.html#defdata/1) but using
`defstruct` and none of the algebraic data type stuff. In addition, this code
is not tested thoroughly, yet. Also, the struct type is always `t()` without
any type arguments.

Notable is, that any field, that doesn't have a default value, will be part of
`@enforce_keys`. Defaults are denoted by a `\\` at the end of a field definition.

```elixir
defmodule SomeStruct do
  use Excentrique
  defstruct do
    id :: non_neg_integer()
    name :: binary() | nil \\ nil
  end
end
```

<details>
<summary>obsolete: Short map. Apparently [es6_maps](https://github.com/kzemek/es6_maps) does a better job (although it is even more invasive).</summary>

~These adaptations require that the AST (Abstract-Syntax-Tree) is rewritten,
before they are further evaluated by the Elixir compiler. The reason is, that
they change the grammar of `Kernel.SpecialForm` functions or macros.~

~This requires either wrapping the code in question with `use Excentrique do
:some_code end` or enabling `Excentrique` in the outer scope, of the current block,
so that native language macros can be wrapped by `Excentrique` to do the rewrite on
the fly. (wrapped macros: `defmodule/2`, `defprotocol/2`, etc.)~

~Similar to the other short map packages, but rewriting the
standard syntax. The variable pinning doesn't work anymore, in Elixir 1.8 and
above.~

```elixir
use Excentrique do
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
use Excentrique
defmodule SomeModule do
  # use short maps here
end
```

</details>
