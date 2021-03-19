defmodule Paddle.PriceTest do
  use ExUnit.Case

  setup do
    bypass = Bypass.open(port: 12345)
    {:ok, bypass: bypass}
  end

  test "get prices", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, ~s(
        {
          "success": true,
          "response": {
            "customer_country": "GB",
            "products": [
              {
                "product_id": 123456,
                "product_title": "My Product 3",
                "currency": "GBP",
                "vendor_set_prices_included_tax": true,
                "price": {
                  "gross": 34.95,
                  "net": 29.13,
                  "tax": 5.83
                },
                "list_price": {
                  "gross": 34.95,
                  "net": 29.13,
                  "tax": 5.83
                },
                "applied_coupon": []
              }
            ]
          }
        }
      ))
    end)

    assert {:ok,
            %{
              "customer_country" => "GB",
              "products" => [
                %{
                  "product_id" => 123_456,
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
            }} == Paddle.Price.get([123_456])
  end
end
