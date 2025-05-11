defmodule AxentDefmodule do
  defmacro __using__(_opts) do
    quote do
      import Kernel, except: [defmodule: 2]
      import AxentDefmodule
      :ok
    end
  end

  defmacro defmodule(module_alias, do: body) do
    quote do
      Kernel.defmodule unquote(module_alias) do
        use Axent do
          unquote(body)
        end
      end
    end
  end

  defmacro defmodule(module_alias, opts) do
    quote do
      Kernel.defmodule(unquote(module_alias), unquote(opts))
    end
  end
end
