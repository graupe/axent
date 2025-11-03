defmodule Axent do
  @moduledoc ~S"""
  > #### WARNING {: .warning}
  >
  > This is work in progress and likely not maintained. It's public on github,
  > so I can test it in real projects.

  Axent contains some syntactic/grammatical extensions for Elixir. Unlike
  other packages that provide similar functionality, this package actually
  overrides core syntactic elements through AST transformation.

  Axent is a personal experiment that provides three main features:

  1. **With-style function definitions** - Use `<-` pattern matching in function bodies
  2. **Typed struct definitions** - Define structs with inline type specifications
  3. **Short map syntax** - Use `%{var}` as shorthand for `%{var: var}`

  ## Installation

  Add `axent` to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [
      {:axent, github: "graupe/axent", runtime: false}
    ]
  end
  ```

  ## Usage

  Enable Axent in your modules:

  ```elixir
  defmodule SomeModule do
    use Axent
    
    # Now you can use all Axent features
    def fetch_user(id) do
      {:ok, user} <- Database.get_user(id)
      {:ok, profile} <- fetch_profile(user.profile_id)
      {user, profile}
    else
      {:error, reason} -> {:error, reason}
    end
  end
  ```

  See the individual module documentation for detailed feature descriptions:
  - `AxentDef` - With-style function definitions
  - `AxentDefstruct` - Typed struct definitions
  - `AxentMap` - Short map syntax
  """

  @doc """
  Enables Axent features in the calling context.

  When called from within a module (inside `defmodule`), it enables:
  - `AxentDefstruct` for typed struct definitions
  - `AxentDef` for with-style function definitions
  - `AxentMap` for short map syntax

  When called outside a module, it enables:
  - `AxentDefmodule` to wrap module definitions with Axent features
  - `AxentMap` for short map syntax in the block

  ## Options

  - `:do` - An optional do-block to transform with AxentMap
  """
  defmacro __using__(opts) do
    body = Keyword.get(opts, :do, :ok)

    if __CALLER__.module do
      quote do
        use AxentDefstruct
        use AxentDef

        use AxentMap do
          unquote(body)
        end
      end
    else
      quote do
        use AxentDefmodule

        use AxentMap do
          unquote(body)
        end
      end
    end
  end
end
