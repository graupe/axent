defmodule Axent do
  @external_resource "README.md"
  @moduledoc File.read!("README.md")

  defmacro __using__(_opts) do
    quote do
      import Kernel, except: [defstruct: 1, def: 2]
      import AxentStruct, only: [defstruct: 1]
      import AxentDef, only: [def: 2]
    end
  end
end
