defmodule Paddle.Checkout.Price do

  @spec get([String.t()], [
      customer_country: String.t(),
      customer_ip: String.t(),
      coupons: String.t()
  ]) :: {:ok, map} | {:error, Paddle.Error.t()}  
  def get(product_ids, opts \\ []) do
    params = %{
      product_ids: Enum.join(product_ids, ","),
      customer_country: opts[:customer_country],
      customer_ip: opts[:customer_ip],
      coupons: opts[:coupons]
    }
    Paddle.Request.get("/2.0/prices", params)
  end
end
