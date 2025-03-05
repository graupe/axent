defmodule AxentDef do
  @moduledoc """
  Provides a `def` macro with extended features over the `Kernel.def` macro.
  """

  defmacro __using__(_opts) do
    quote do
      import Kernel, except: [def: 2]
      import AxentDef, only: [def: 2]
    end
  end

  @doc ~S"""
  Extends the Elixir `def` macro to support `<-` assigments on the top-level
  do-block.

  ## Examples

  The following
  ```elixir
  defmodule TestModule do
    def some_function do
      data when is_binary(data) <- IO.read(:eof)
      computed_data =
        if length(data) > 3 do
          {:error, :too_long}
        else
          computed_data
        end
      some_unrelated_call(computed_data)
      {:ok, value} <- Sketchy.IO.call(computed_data)
      value
    else
      {:error, reason} ->
        require Logger
        Logger.warning("Sketchy IO call failed: #{inspect(reason}")
        ""
      :eof -> ""
    end
  end
  ```

  gets translated to
  ```elixir
  defmodule TestModule do
    def some_function do
      with data when is_binary(data) <- IO.read(:eof),
          computed_data = if(length(data) > 3, do: {:error, :too_long}, else: computed_data),
          some_unrelated_call(computed_data),
          {:ok, value} <- Sketchy.IO.call(computed_data) do
        value
      else
        {:error, reason} ->
          require Logger
          Logger.warning("Sketchy IO call failed: #{inspect(reason}")
          ""
        :eof -> ""
      end
    end
  end
  ```
  """
  defmacro def(definition, opts) do
    if not Keyword.has_key?(opts, :do) or not has_axent?(opts[:do]) do
      # regular `def`
      quote do
        Kernel.def(unquote(definition), unquote(opts))
      end
    else
      deny_block(opts, :catch, __CALLER__)
      deny_block(opts, :rescue, __CALLER__)

      {result, clauses} = extract_do(opts[:do])

      deny_implicit_results(result, __CALLER__)

      else_clauses =
        if Keyword.has_key?(opts, :else) do
          opts[:else]
        else
          quote do
            unmatched -> unmatched
          end
        end

      quote do
        Kernel.def unquote(definition) do
          with unquote_splicing(clauses) do
            unquote(result)
          else
            unquote(else_clauses)
          end
        end
      end
    end
  end

  defp extract_do({:__block__, _, expressions}), do: List.pop_at(expressions, -1)
  defp extract_do(otherwise), do: {otherwise, []}

  defp has_axent?({:<-, _, _}), do: true
  defp has_axent?({:__block__, _, nodes}), do: Enum.any?(nodes, &has_axent?/1)
  defp has_axent?(_), do: false

  defp deny_block(opts, block_key, caller) do
    if Keyword.has_key?(opts, block_key) do
      meta =
        case opts[block_key] do
          [{_, meta, _} | _] -> meta
          {_, meta, _} -> meta
          _otherwise -> []
        end

      raise SyntaxError,
        description: "Don't mix `#{block_key}` blocks and Axent syntax",
        line: meta[:line],
        column: meta[:column],
        file: caller.file
    end
  end

  defp deny_implicit_results(result, caller) do
    with {:<-, meta, _} <- result do
      raise SyntaxError,
        description:
          "Expected non-match assignment as last expression, but got: #{Macro.to_string(result)}",
        line: meta[:line],
        column: meta[:column],
        file: caller.file
    end
  end
end
