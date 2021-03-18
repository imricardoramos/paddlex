defmodule Paddle.Checkout.UserHistory do
  @spec get(String.t(), [vendor_id: integer, product_id: integer])
    :: {:ok, map} | {:error, Paddle.Error.t()} 
  def get(email, opts \\ []) do
    params = 
      %{
        email: email,
        vendor_id: opts[:vendor_id],
        product_id: opts[:product_id]
      }
      |> Enum.reject(fn {_, v} -> is_nil(v) end)
      |> Enum.into(%{})
    Paddle.Request.get("/2.0/user/history", params)
  end
end
