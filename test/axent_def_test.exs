defmodule AxentDefTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  @compile {:no_warn_undefined, [AxentDefTest.Test]}

  setup do
    if Code.loaded?(AxentDefTest.Test) do
      module = AxentDefTest.Test.module_info(:module)
      :code.purge(module)
      :code.delete(module)
    end

    :ok
  end

  @test_ok ~S"""
      defmodule AxentDefTest.Test do
        @compile {:ignore_module_conflict, true}
        use AxentDef

        def test_ok do
          {:ok, value} <- {:ok, :some_value}
          value
        else
          _ -> :error
        end
      end
  """
  @test_ok_with_warning ~S"""
      defmodule AxentDefTest.Test do
        @compile {:ignore_module_conflict, true}
        use AxentDef

        def test_warning_ok do
          {:ok, value} <- {:ok, :some_value}
        else
          _ -> :error
        end
      end
  """
  @test_error ~S"""
      defmodule AxentDefTest.Test do
        @compile {:ignore_module_conflict, true}
        use AxentDef

        def test_error do
          {:ok, value} <- {:error, {:some_reason, "message"}}
          value
        else
          _ -> :error
        end
      end
  """
  @test_normal_def ~S"""
    defmodule AxentDefTest.Test do
      @compile {:ignore_module_conflict, true}
      use AxentDef
      def normal_fn, do: :original

      def normal_fn_with_rescue do
        raise "error"
      rescue
        _ -> :error
      end

      def normal_fn_with_rescue_and_catch do
        throw(:something)
      rescue
        _ -> :error
      catch
        :something -> :caught
      end
    end
  """

  test "axent def" do
    Code.compile_string(@test_ok)
    assert AxentDefTest.Test.test_ok() == :some_value
  end

  test "axent def with warning about implicit :ok" do
    assert capture_io(fn ->
             Code.compile_string(@test_ok_with_warning)
           end) =~ "Implicit return value :ok"

    assert AxentDefTest.Test.test_warning_ok() == :ok
  end

  test "axent def with :error case" do
    Code.compile_string(@test_error)
    assert AxentDefTest.Test.test_error() == :error
  end

  test "standard def behavior preserved" do
    Code.compile_string(@test_normal_def)
    assert AxentDefTest.Test.normal_fn() == :original
    assert AxentDefTest.Test.normal_fn_with_rescue() == :error
    assert AxentDefTest.Test.normal_fn_with_rescue_and_catch() == :caught
  end
end
