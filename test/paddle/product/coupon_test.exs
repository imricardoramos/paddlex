defmodule Paddle.CouponTest do
  use ExUnit.Case

  setup do
    bypass = Bypass.open(port: 12345)
    {:ok, bypass: bypass}
  end

  test "create coupon", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, ~s(
        {
          "success": true,
          "response": {
            "coupon_codes": [
              "TEST-03C532BD",
              "TEST-491AC84D",
              "TEST-899202BB",
              "TEST-96518CAF",
              "TEST-2A2A7594"
            ]
          }
        }
      ))
    end)

    params = %{
      coupon_prefix: "TEST",
      num_coupons: 5,
      description: "Test Coupon",
      coupon_type: "checkout",
      discount_type: "percentage",
      discount_amount: 10
    }

    assert {:ok,
            %{
              coupon_codes: [
                "TEST-03C532BD",
                "TEST-491AC84D",
                "TEST-899202BB",
                "TEST-96518CAF",
                "TEST-2A2A7594"
              ]
            }} == Paddle.Coupon.create(params)
  end

  test "list coupons", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, ~s(
        {
          "success": true,
          "response": [
            {
              "coupon": "56604810a6990",
              "description": "56604810a6dcd",
              "discount_type": "percentage",
              "discount_amount": 0.5,
              "discount_currency": "USD",
              "allowed_uses": 3,
              "times_used": 2,
              "is_recurring": true,
              "expires": "2020-12-03 00:00:00"
            }
          ]
        }
      ))
    end)

    assert {:ok,
            [
              %Paddle.Coupon{
                coupon: "56604810a6990",
                description: "56604810a6dcd",
                discount_type: "percentage",
                discount_amount: 0.5,
                discount_currency: "USD",
                allowed_uses: 3,
                times_used: 2,
                is_recurring: true,
                expires: ~U"2020-12-03 00:00:00Z"
              }
            ]} == Paddle.Coupon.list(1234)
  end

  test "update coupon", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, ~s(
        {
          "success": true,
          "response": {
            "updated": 1
          }
        }
      ))
    end)

    params = %{
      coupon_code: "TEST",
      discount_amount: 20
    }

    assert {:ok, 1} == Paddle.Coupon.update(params)
  end

  test "delete coupon", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, ~s(
        {
          "success": true
        }
      ))
    end)

    assert {:ok, nil} == Paddle.Coupon.delete("TEST")
  end
end
