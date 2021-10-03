defmodule Paddle.HelpersTest do
  use ExUnit.Case, async: true

  import Paddle.Helpers

  defmodule TestStruct do
    defstruct [:some_field, :some_other_field]
  end

  test "map_to_struct/2 converts string map to struct" do
    map = %{
      "some_field" => "some field value",
      "some_other_field" => "some other field value",
      "some_unknown_field" => "some unknown field value"
    }

    assert %TestStruct{
             some_field: "some field value",
             some_other_field: "some other field value"
           } = map_to_struct(map, TestStruct)
  end

  test "maybe_convert_datetime/2 converts datetime if present" do
    struct = %TestStruct{
      some_field: "some field value",
      some_other_field: "2015-08-14 13:28:19"
    }

    assert %TestStruct{
             some_field: "some field value",
             some_other_field: ~U"2015-08-14 13:28:19Z"
           } = maybe_convert_datetime(struct, :some_other_field)
  end

  test "maybe_convert_datetime/2 does nothing if datetime if not present" do
    struct = %TestStruct{
      some_field: "some field value",
      some_other_field: nil
    }

    assert %TestStruct{
             some_field: "some field value",
             some_other_field: nil
           } = maybe_convert_datetime(struct, :some_other_field)
  end

  test "maybe_convert_date/2 converts date if present" do
    struct = %TestStruct{
      some_field: "some field value",
      some_other_field: "2015-08-14"
    }

    assert %TestStruct{
             some_field: "some field value",
             some_other_field: ~D"2015-08-14"
           } = maybe_convert_date(struct, :some_other_field)
  end

  test "maybe_convert_date/2 does nothing if date if not present" do
    struct = %TestStruct{
      some_field: "some field value",
      some_other_field: nil
    }

    assert %TestStruct{
             some_field: "some field value",
             some_other_field: nil
           } = maybe_convert_date(struct, :some_other_field)
  end
end
