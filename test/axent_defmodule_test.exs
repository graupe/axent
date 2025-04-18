defmodule AxentDefmoduleTest do
  use ExUnit.Case, async: false
  doctest AxentDefmodule, import: true

  test "Axent extended behaviour" do
    Code.compile_string(~S"""
    use Axent
    defmodule AxentDefmoduleTest.Test do
      default_value = 10
      defstruct do
        axent :: any() \\ %{default_value}
      end
    end
    """)
  end
end
