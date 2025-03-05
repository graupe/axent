defmodule AxentStructTest do
  use ExUnit.Case, async: true
  doctest AxentStruct, import: true

  defmodule SampleStruct do
    use AxentStruct

    @typedoc "Test struct for validations"
    defstruct do
      username :: String.t() \\ "anon"
      age :: non_neg_integer()
      email :: String.t() | nil
    end
  end

  defmodule LegacyStruct do
    use Axent
    defstruct [:name, some_default: "mehehe"]
  end

  describe "axent defstruct implementation" do
    test "generates valid struct with defaults" do
      assert struct!(SampleStruct, age: 25, email: nil) == %SampleStruct{
               username: "anon",
               age: 25,
               email: nil
             }
    end

    test "enforces required fields like Kernel.struct" do
      assert_raise ArgumentError, ~r/age/, fn ->
        struct!(SampleStruct, username: "test")
      end
    end

    test "enforces required fields like Kernel.struct that can be nil" do
      assert_raise ArgumentError, ~r/email/, fn ->
        struct!(SampleStruct, username: "test", age: 22)
      end

      assert struct!(SampleStruct, username: "test", age: 22, email: nil)
    end
  end

  describe "is mostly compatible to Kernel.defstruct" do
    test "Still works with regular `defstruct` notation" do
      assert struct!(LegacyStruct) == %LegacyStruct{name: nil, some_default: "mehehe"}
    end
  end
end
