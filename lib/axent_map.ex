defmodule AxentMap do
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
