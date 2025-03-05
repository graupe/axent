defmodule AxentDef do
  defp extract_expressions({:__block__, _, expressions}), do: expressions
  defp extract_expressions(otherwise), do: otherwise

  defmacro def(definition, opts) do
    if Keyword.has_key?(opts, :do) and Keyword.has_key?(opts, :else) do
      expressions = extract_expressions(opts[:do])

      quote do
        Kernel.def unquote(definition) do
          with unquote_splicing(expressions) do
            :ok
          else
            _ -> :error
          end
        end
      end
    else
      quote do
        Kernel.def(unquote(definition), unquote(opts))
      end
    end
  end

  defmacro __using__(_opts) do
    quote do
      import Kernel, except: [def: 2]
      import AxentDef, only: [def: 2]
    end
  end
end
