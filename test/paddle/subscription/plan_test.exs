defmodule Paddle.PlanTest do
  use ExUnit.Case

  setup do
    bypass = Bypass.open(port: 12345)
    {:ok, bypass: bypass}
  end

  test "lists plans", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, ~s(
        {
          "success": true,
          "response": [
            {
              "id": 9636,
              "name": "Test",
              "billing_type": "day",
              "billing_period": 1,
              "initial_price": {
                "USD": "0.00"
              },
              "recurring_price": {
                "USD": "10.00"
              },
              "trial_days": 0
            }
          ]
        }
      ))
    end)

    assert {:ok,
            [
              %Paddle.Plan{
                billing_period: 1,
                billing_type: "day",
                id: 9636,
                initial_price: %{"USD" => "0.00"},
                name: "Test",
                recurring_price: %{"USD" => "10.00"},
                trial_days: 0
              }
            ]} == Paddle.Plan.list()
  end

  test "create plan", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, ~s(
        {
          "success": true,
          "response": {
            "product_id": 502198
          }
        }
      ))
    end)

    params = %{
      main_currency_code: "USD",
      plan_length: 123,
      plan_name: "Test",
      plan_trial_days: "123",
      plan_type: "day",
      recurring_price_eur: "10.00",
      recurring_price_gbp: "20.00",
      recurring_price_usd: "30.00"
    }

    assert {:ok, 502_198} == Paddle.Plan.create(params)
  end
end
