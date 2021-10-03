defmodule Paddle.Helpers do
  @moduledoc """
  Helpers
  """
  def map_to_struct(map, module) do
    processed_map =
      Map.keys(module.__struct__)
      |> List.delete(:__struct__)
      |> Enum.reduce(%{}, fn key, acc ->
        value = Map.get(map, Atom.to_string(key))
        Map.put(acc, key, value)
      end)

    struct(module, processed_map)
  end

  def maybe_convert_datetime(map, key) do
    datetime_string = Map.get(map, key)

    if datetime_string do
      {:ok, datetime, 0} = DateTime.from_iso8601(datetime_string <> "Z")
      Map.replace(map, key, datetime)
    else
      map
    end
  end

  def maybe_convert_date(map, key) do
    date_string = Map.get(map, key)

    if date_string do
      date = Date.from_iso8601!(date_string)
      Map.replace(map, key, date)
    else
      map
    end
  end
end
