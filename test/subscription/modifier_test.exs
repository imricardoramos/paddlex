defmodule Paddle.Subscription.ModifierTest do
  use ExUnit.Case

  setup do
    bypass = Bypass.open(port: 12345)
    {:ok, bypass: bypass}
  end

  test "create modifier", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, ~s(
        {
          "success": true,
          "response": {
            "subscription_id": 12345,
            "modifier_id": 10
          }
        }
      ))
    end)
    params = %{
      subscription_id: 12345,
      modifier_recurring: true,
      modifier_amount: 20,
      modifier_description: "TestModifier"
    }
    assert {:ok, %{
      subscription_id: 12345,
      modifier_id: 10
    }} == Paddle.Subscription.Modifier.create(params)
  end

  test "list modifiers", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, ~s(
        {
          "success": true,
          "response": [
            {
              "modifier_id": 10,
              "subscription_id": 12345,
              "amount": "1.000",
              "currency": "USD",
              "is_recurring": false,
              "description": "Example Modifier"
            }
          ]
        }
      ))
    end)
    assert {:ok, [%Paddle.Subscription.Modifier{
      modifier_id: 10,
      subscription_id: 12345,
      amount: "1.000",
      currency: "USD",
      is_recurring: false,
      description: "Example Modifier"
    }]} == Paddle.Subscription.Modifier.list()
  end

  test "delete modifier", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, ~s(
        {
          "success": true
        }
      ))
    end)
    assert {:ok, nil} == Paddle.Subscription.Modifier.delete(10)
  end
end
