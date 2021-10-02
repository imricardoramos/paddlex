defmodule Paddle.OneOffChargeTest do
  use ExUnit.Case

  setup do
    bypass = Bypass.open(port: 12_345)
    {:ok, bypass: bypass}
  end

  test "create one-off charge", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, ~s(
        {
          "success": true,
          "response": {
            "invoice_id": 1,
            "subscription_id": 1,
            "amount": "10.00",
            "currency": "USD",
            "payment_date": "2018-09-21",
            "receipt_url": "https://my.paddle.com/receipt/1-1/3-chre8a53a2724c6-42781cb91a"
          }
        }
      ))
    end)

    assert {:ok,
            %Paddle.OneOffCharge{
              invoice_id: 1,
              subscription_id: 1,
              amount: "10.00",
              currency: "USD",
              payment_date: ~D"2018-09-21",
              receipt_url: "https://my.paddle.com/receipt/1-1/3-chre8a53a2724c6-42781cb91a"
            }} == Paddle.OneOffCharge.create(2746, 10, "TestCharge")
  end
end
