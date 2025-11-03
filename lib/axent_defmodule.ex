defmodule AxentDefmodule do
  @moduledoc """
  Provides an extended `defmodule` macro that automatically applies Axent
  transformations to the module body.

  When used, this module wraps `defmodule` definitions with `use Axent`,
  enabling all Axent features (short maps, extended def, typed defstruct)
  within the module scope without explicit `use Axent` calls.
  """

  defmacro __using__(_opts) do
    quote do
      import Kernel, except: [defmodule: 2]
      import AxentDefmodule
      :ok
    end
  end

  @doc """
  Defines a module with Axent features automatically enabled.

  This macro wraps `Kernel.defmodule/2` and automatically injects
  `use Axent` into the module body, enabling all Axent transformations.
  """
  defmacro defmodule(module_alias, do: body) do
    quote do
      Kernel.defmodule unquote(module_alias) do
        use Axent do
          unquote(body)
        end
      end
    end
  end

  @doc """
  Fallback to standard `Kernel.defmodule/2` for non-do block forms.
  """
  defmacro defmodule(module_alias, opts) do
    quote do
      Kernel.defmodule(unquote(module_alias), unquote(opts))
    end
  end
end
