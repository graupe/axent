defmodule AxentMap do
  @moduledoc """
  Provides short map syntax for Elixir, similar to ES6 JavaScript object literals.

  Allows using `%{var}` as shorthand for `%{var: var}`, making code more concise
  when map keys match variable names.

  ## Examples

      use AxentMap do
        name = "Alice"
        age = 30
        %{name, age}  # expands to %{name: name, age: age}
      end

  Note: Variable pinning with `^` is not supported in Elixir 1.8+.
  """

  defmacro __using__(do: body) do
    Macro.postwalk(body, &rewrite/1)
  end

  defmacro __using__(_opts) do
  end

  defp rewrite({:%{}, meta, map_args}) when is_list(map_args), do: {:%{}, meta, maxmin(map_args)}
  defp rewrite(verbatim), do: verbatim

  defp maxmin([]), do: []

  defp maxmin([pin = {:^, _pin_meta, [{var_name, _var_meta, context}]} | args])
       when is_atom(context),
       do: [{var_name, pin} | maxmin(args)]

  defp maxmin([var = {var_name, _meta, context} | args]) when is_atom(context),
    do: [{var_name, var} | maxmin(args)]

  defp maxmin([arg | args]), do: [arg | maxmin(args)]
end
