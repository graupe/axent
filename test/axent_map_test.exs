defmodule AxentMapTest do
  use ExUnit.Case, async: false
  doctest AxentMap, import: true

  describe "Axent extended behaviour" do
    test "short map, varname is keyname" do
      assert {%{aaa: :bbb}, [aaa: :bbb]} =
               Code.eval_string(~S"""
                 aaa = :bbb
                 use AxentMap do
                   %{aaa}
                 end
               """)
    end

    test "short map, bind var to keyname" do
      assert {%{aaa: :bbb}, [aaa: :bbb]} =
               Code.eval_string(~S"""
                 use AxentMap do
                   %{aaa} = %{aaa: :bbb}
                 end
               """)
    end

    # this did work until at least up to Elixir 1.7, but doesn't work for 1.8
    #    test "short map, pin is keyname" do
    #      assert {%{aaa: :bbb}, [aaa: :bbb]} =
    #               Code.eval_string(~S"""
    #                 aaa = :bbb
    #                 use AxentMap do
    #                   %{^aaa} = %{aaa: :bbb}
    #                 end
    #               """)
    #    end
  end

  describe "Kernel (default) behaviour" do
    test "standard %{} is preserved" do
      assert {%{aaa: :bbb}, []} = Code.eval_string("%{aaa: :bbb}")
    end
  end
end
