defmodule Paddle.Checkout.OrderDetails do
  @spec get(String.t(), String.t()) :: {:ok, map} | {:error, Paddle.Error.t()} 
  def get(checkout_id, callback_name \\ nil) do
    params = 
      %{checkout_id: checkout_id,
        callback_name: callback_name
      }
      |> Enum.reject(fn {_, v} -> is_nil(v) end)
      |> Enum.into(%{})
    Paddle.Request.get("/1.0/order", params)
  end
end
