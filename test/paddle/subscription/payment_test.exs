defmodule Paddle.SubscriptionPaymentTest do
  use ExUnit.Case

  setup do
    bypass = Bypass.open(port: 12_345)
    {:ok, bypass: bypass}
  end

  test "list payments", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, ~s(
        {
          "success": true,
          "response": [
            {
              "id": 8936,
              "subscription_id": 2746,
              "amount": 1,
              "currency": "USD",
              "payout_date": "2015-10-15",
              "is_paid": 0,
              "is_one_off_charge": 0,
              "receipt_url": "https://www.paddle.com/receipt/469214-8936/1940881-chrea0eb34164b5-f0d6553bdf"
            }
          ]
        }
      ))
    end)

    assert {:ok,
            [
              %Paddle.SubscriptionPayment{
                id: 8936,
                subscription_id: 2746,
                amount: 1,
                currency: "USD",
                payout_date: "2015-10-15",
                is_paid: 0,
                is_one_off_charge: 0,
                receipt_url:
                  "https://www.paddle.com/receipt/469214-8936/1940881-chrea0eb34164b5-f0d6553bdf"
              }
            ]} == Paddle.SubscriptionPayment.list()
  end

  test "reschedule payment", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, ~s(
        {
          "success": true
        }
      ))
    end)

    assert {:ok, nil} == Paddle.SubscriptionPayment.reschedule(10, ~D"2015-10-15")
  end
end
