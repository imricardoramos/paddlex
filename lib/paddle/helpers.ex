defmodule Paddle.Helpers do

  def map_to_struct(map, module) do
    processed_map = Map.keys(module.__struct__)
      |> List.delete(:__struct__)
      |> Enum.reduce(%{}, fn key, acc -> 
        value = Map.get(map, Atom.to_string(key))
        Map.put(acc, key, value)
      end)
    struct(module, processed_map)
  end

end
