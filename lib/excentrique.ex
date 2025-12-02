defmodule Excentrique do
  @moduledoc ~S"""
  > #### WARNING {: .warning}
  >
  > This is work in progress and likely not maintained. It's public on github,
  > so I can test it in real projects.

  Excentrique contains some syntactic/grammatical extensions for Elixir. Opposed to
  some other packages that provide similar functionality, this package actually
  overrides core syntactic elements.

  Excentrique is a personal experiment.

  Use it in your project by adding it to your `mix.exs` dependencies
  ```elixir
  def deps do
    [
      {:excentrique, github: "graupe/excentrique"}
    ]
  end
  ```
  and invoking it in your modules of choice
  ```elixir
  defmodule SomeModule do
    use Excentrique
    ...
  end
  ```
  """

  defmacro __using__(opts) do
    body = Keyword.get(opts, :do, :ok)

    if __CALLER__.module do
      quote do
        use Excentrique.Defstruct
        use Excentrique.Def

        use Excentrique.Map do
          unquote(body)
        end
      end
    else
      quote do
        use Excentrique.Defmodule

        use Excentrique.Map do
          unquote(body)
        end
      end
    end
  end
end
