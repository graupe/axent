defmodule Axent do
  @moduledoc ~S"""
  > #### WARNING {: .warning}
  >
  > This is work in progress and likely not maintained. It's public on github,
  > so I can test it in real projects.

  Axent contains some syntactic/grammatical extensions for Elixir. Opposed to
  some other packages that provide similar functionality, this package actually
  overrides core syntactic elements.

  Axent is a personal experiment.

  Use it in your project by adding it to your `mix.exs` dependencies
  ```elixir
  def deps do
    [
      {:axent, github: "graupe/axent"}
    ]
  end
  ```
  and invoking it in your modules of choice
  ```elixir
  defmodule SomeModule do
    use Axent
    ...
  end
  ```
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
