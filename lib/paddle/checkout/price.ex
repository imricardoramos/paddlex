defmodule Paddle.Price do
  @moduledoc """
  Price
  """
  @doc """
  Retrieve prices for one or multiple products or plans

  ## Examples

      Paddle.Price.get([123456])
      {:ok, %{
        "customer_country" => "GB",
        "products" => [
          %{
            "product_id" => 123456,
            "product_title" => "My Product 3",
            "currency" => "GBP",
            "vendor_set_prices_included_tax" => true,
            "price" => %{
              "gross" => 34.95,
              "net" => 29.13,
              "tax" => 5.83
            },
            "list_price" => %{
              "gross" => 34.95,
              "net" => 29.13,
              "tax" => 5.83
            },
            "applied_coupon" => []
          }
        ]
      }}
  """
  @spec get([String.t()],
          customer_country: String.t(),
          customer_ip: String.t(),
          coupons: String.t()
        ) :: {:ok, map} | {:error, Paddle.Error.t()}
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
