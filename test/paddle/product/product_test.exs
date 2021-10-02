defmodule Paddle.ProductTest do
  use ExUnit.Case

  setup do
    bypass = Bypass.open(port: 12_345)
    {:ok, bypass: bypass}
  end

  test "list products", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, ~s(
        {
          "success": true,
          "response": {
            "total": 2,
            "count": 2,
            "products": [
              {
                "id": 489171,
                "name": "A Product",
                "description": "A description of the product.",
                "base_price": 58,
                "sale_price": null,
                "currency": "USD",
                "screenshots": [],
                "icon": "https://paddle-static.s3.amazonaws.com/email/2013-04-10/og.png"
              },
              {
                "id": 489278,
                "name": "Another Product",
                "description": null,
                "base_price": 39.99,
                "sale_price": null,
                "currency": "GBP",
                "screenshots": [],
                "icon": "https://paddle.s3.amazonaws.com/user/91/489278geekbench.png"
              }
            ]
          }
        }
      ))
    end)

    assert {:ok,
            [
              %Paddle.Product{
                id: 489_171,
                name: "A Product",
                description: "A description of the product.",
                base_price: 58,
                sale_price: nil,
                currency: "USD",
                screenshots: [],
                icon: "https://paddle-static.s3.amazonaws.com/email/2013-04-10/og.png"
              },
              %Paddle.Product{
                id: 489_278,
                name: "Another Product",
                description: nil,
                base_price: 39.99,
                sale_price: nil,
                currency: "GBP",
                screenshots: [],
                icon: "https://paddle.s3.amazonaws.com/user/91/489278geekbench.png"
              }
            ]} == Paddle.Product.list()
  end
end
