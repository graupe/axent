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
  """

  defmacro __using__(_opts) do
    quote do
      import Kernel, except: [defstruct: 1, def: 2]
      import AxentStruct, only: [defstruct: 1]
      import AxentDef, only: [def: 2]
    end
  end
end
