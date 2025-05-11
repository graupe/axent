defmodule AxentDefstructTest do
  use ExUnit.Case, async: true
  doctest AxentDefstruct, import: true

  setup do
    if Code.loaded?(SampleStruct) do
      module = SampleStruct.module_info(:module)
      :code.purge(module)
      :code.delete(module)
    end

    :ok
  end

  @axent_struct ~S"""
  defmodule SampleStruct do
    use Axent

    @typedoc "Test struct for validations"
    defstruct do
      username :: String.t() \\ "anon"
      age :: non_neg_integer()
      email :: String.t() | nil
    end
  end
  """

  @axent_struct_one_field ~S"""
  defmodule SampleStruct do
    use Axent

    @typedoc "Test struct with a single field"
    defstruct do
      one :: :field
    end
  end
  """

  @legacy_struct ~S"""
  defmodule SampleStruct do
    use Axent
    defstruct [:name, some_default: "some_value"]
  end
  """

  describe "axent defstruct implementation" do
    test "generates valid struct with defaults" do
      Code.compile_string(@axent_struct)

      assert inspect(struct!(SampleStruct, age: 25, email: nil)) =~
               ~S(%SampleStruct{username: "anon", age: 25, email: nil})
    end

    test "generates single field struct" do
      Code.compile_string(@axent_struct_one_field)
      assert inspect(struct!(SampleStruct, one: :field)) =~ ~S(%SampleStruct{one: :field})
    end

    test "enforces required fields like Kernel.struct" do
      assert_raise ArgumentError, ~r/age/, fn ->
        Code.compile_string(@axent_struct)
        struct!(SampleStruct, username: "test")
      end
    end

    test "enforces required fields like Kernel.struct that can be nil" do
      Code.compile_string(@axent_struct)

      assert_raise ArgumentError, ~r/email/, fn ->
        struct!(SampleStruct, username: "test", age: 22)
      end

      assert struct!(SampleStruct, username: "test", age: 22, email: nil)
    end
  end

  describe "is mostly compatible to Kernel.defstruct" do
    test "Still works with regular `defstruct` notation" do
      Code.compile_string(@legacy_struct)

      assert inspect(struct!(SampleStruct)) =~
               ~S(%SampleStruct{name: nil, some_default: "some_value"})
    end
  end
end
