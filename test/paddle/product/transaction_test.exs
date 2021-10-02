defmodule Paddle.TransactionTest do
  use ExUnit.Case

  setup do
    bypass = Bypass.open(port: 12_345)
    {:ok, bypass: bypass}
  end

  test "list transactions", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, ~s(
        {
          "success": true,
          "response": [
            {
              "order_id": "1042907-384786",
              "checkout_id": "4795118-chre895f5cfaf61-4d7dafa9df",
              "amount": "5.00",
              "currency": "USD",
              "status": "completed",
              "created_at": "2017-01-22 00:38:43",
              "passthrough": null,
              "product_id": 12345,
              "is_subscription": true,
              "is_one_off": false,
              "subscription": {
                "subscription_id": 123456,
                "status": "active"
              },
              "user": {
                "user_id": 29777,
                "email": "example@paddle.com",
                "marketing_consent": true
              },
              "receipt_url": "https://my.paddle.com/receipt/1042907-384786/4795118-chre895f5cfaf61-4d7dafa9df"
            },
            {
              "order_id": "1042907-384785",
              "checkout_id": "4795118-chre895f5cfaf61-4d7dafa9df",
              "amount": "5.00",
              "currency": "USD",
              "status": "refunded",
              "created_at": "2016-12-07 12:25:09",
              "passthrough": null,
              "product_id": 12345,
              "is_subscription": true,
              "is_one_off": true,
              "subscription": {
                "subscription_id": 123456,
                "status": "active"
              },
              "user": {
                "user_id": 29777,
                "email": "example@paddle.com",
                "marketing_consent": true
              },
              "receipt_url": "https://my.paddle.com/receipt/1042907-384785/4795118-chre895f5cfaf61-4d7dafa9df"
            }
          ]
        }
      ))
    end)

    assert {:ok,
            [
              %Paddle.Transaction{
                order_id: "1042907-384786",
                checkout_id: "4795118-chre895f5cfaf61-4d7dafa9df",
                amount: "5.00",
                currency: "USD",
                status: "completed",
                created_at: ~U"2017-01-22 00:38:43Z",
                passthrough: nil,
                product_id: 12_345,
                is_subscription: true,
                is_one_off: false,
                subscription: %{
                  "subscription_id" => 123_456,
                  "status" => "active"
                },
                user: %{
                  "user_id" => 29_777,
                  "email" => "example@paddle.com",
                  "marketing_consent" => true
                },
                receipt_url:
                  "https://my.paddle.com/receipt/1042907-384786/4795118-chre895f5cfaf61-4d7dafa9df"
              },
              %Paddle.Transaction{
                order_id: "1042907-384785",
                checkout_id: "4795118-chre895f5cfaf61-4d7dafa9df",
                amount: "5.00",
                currency: "USD",
                status: "refunded",
                created_at: ~U"2016-12-07 12:25:09Z",
                passthrough: nil,
                product_id: 12_345,
                is_subscription: true,
                is_one_off: true,
                subscription: %{
                  "subscription_id" => 123_456,
                  "status" => "active"
                },
                user: %{
                  "user_id" => 29_777,
                  "email" => "example@paddle.com",
                  "marketing_consent" => true
                },
                receipt_url:
                  "https://my.paddle.com/receipt/1042907-384785/4795118-chre895f5cfaf61-4d7dafa9df"
              }
            ]} == Paddle.Transaction.list("user", 29_777)
  end
end
