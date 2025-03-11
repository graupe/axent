defmodule AxentDefTest do
  use ExUnit.Case
  doctest AxentDef, import: true
  # the module is only created within the test
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
        use AxentDef

        def test do
          {:ok, value} <- {:ok, :some_value}
          value
        else
          _ -> :error
        end
      end
  """
  @test_ok_private ~S"""
      defmodule AxentDefTest.Test do
        use AxentDef

        def test, do: testp()

        defp testp do
          {:ok, value} <- {:ok, :some_value}
          value
        else
          _ -> :error
        end
      end
  """

  @test_ok_complex_result ~S"""
      defmodule AxentDefTest.Test do
        use AxentDef

        def test do
          {:ok, value} <- {:ok, 4}
          if value > 3 do
            :too_large
          else
            value
          end
        else
          _ -> :error
        end
      end
  """
  @test_ok_complex_intermediate ~S"""
      defmodule AxentDefTest.Test do
        use AxentDef

        def test do
          {:ok, value} <- {:ok, 4}
          value = if value > 3 do
            :too_large
          else
            value
          end
          value
        else
          _ -> :error
        end
      end
  """
  @test_ok_no_else ~S"""
      defmodule AxentDefTest.Test do
        use AxentDef

        def test do
          {:ok, value} <- {:ok, :some_value}
          value
        end
      end
  """
  @test_ok_with_warning ~S"""
      defmodule AxentDefTest.Test do
        use AxentDef

        def test do
          {:ok, _value} <- {:ok, :some_value}
        else
          _ -> :error
        end
      end
  """

  @test_ok_with_catch_discurage ~S"""
      defmodule AxentDefTest.Test do
        use AxentDef

        def test do
          {:ok, value} <- {:ok, :some_value}
          :ok
        catch
          _ -> raise "SomeError"
        else
          _ -> :error
        end
      end
  """
  @test_ok_with_rescue_discurage ~S"""
      defmodule AxentDefTest.Test do
        use AxentDef

        def test do
          {:ok, _value} <- {:ok, :some_value}
          :ok
        rescue
          _ -> raise "SomeError"
        else
          _ -> :error
        end
      end
  """
  @test_error ~S"""
      defmodule AxentDefTest.Test do
        use AxentDef

        def test do
          {:ok, value} <- {:error, {:some_reason, "message"}}
          value
        else
          _ -> :error
        end
      end
  """
  @test_normal_def ~S"""
    defmodule AxentDefTest.Test do
      use AxentDef
      def normal_fn
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

  describe "Axent extended behaviour" do
    test "axent def" do
      Code.compile_string(@test_ok)
      assert AxentDefTest.Test.test() == :some_value
    end

    test "axent defp" do
      Code.compile_string(@test_ok_private)
      assert AxentDefTest.Test.test() == :some_value
    end

    test "axent def complex result" do
      Code.compile_string(@test_ok_complex_result)
      assert AxentDefTest.Test.test() == :too_large
    end

    test "axent def complex intermediate" do
      Code.compile_string(@test_ok_complex_intermediate)
      assert AxentDefTest.Test.test() == :too_large
    end

    test "axent def no else" do
      Code.compile_string(@test_ok_no_else)
      assert AxentDefTest.Test.test() == :some_value
    end

    test "axent def error on implicit nil return" do
      assert_raise SyntaxError, ~r"Expected non-match assignment as last expression", fn ->
        Code.compile_string(@test_ok_with_warning)
      end
    end

    test "axent def error on `<-` with `rescue` or `catch`" do
      assert_raise SyntaxError, ~r"Don't mix `rescue` blocks and Axent syntax", fn ->
        Code.compile_string(@test_ok_with_rescue_discurage)
      end

      assert_raise SyntaxError, ~r"Don't mix `catch` blocks and Axent syntax", fn ->
        Code.compile_string(@test_ok_with_catch_discurage)
      end
    end

    test "axent def with :error case" do
      Code.compile_string(@test_error)
      assert AxentDefTest.Test.test() == :error
    end
  end

  describe "Kernel (default) behaviour" do
    test "standard def behavior preserved" do
      Code.compile_string(@test_normal_def)
      assert AxentDefTest.Test.normal_fn() == :original
      assert AxentDefTest.Test.normal_fn_with_rescue() == :error
      assert AxentDefTest.Test.normal_fn_with_rescue_and_catch() == :caught
    end
  end
end
