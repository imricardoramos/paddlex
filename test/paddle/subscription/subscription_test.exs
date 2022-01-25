defmodule Paddle.SubscriptionTest do
  use ExUnit.Case

  setup do
    bypass = Bypass.open(port: 12_345)
    {:ok, bypass: bypass}
  end

  test "lists users", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, ~s(
        {
          "success": true,
          "response": [
            {
              "subscription_id": 502198,
              "plan_id": 496199,
              "user_id": 285846,
              "user_email": "name@example.com",
              "marketing_consent": true,
              "update_url": "https://checkout.paddle.com/subscription/update?user=12345&subscription=87654321&hash=eyJpdiI6Ik1RTE1nbHpXQmtJUG5...",
              "cancel_url": "https://checkout.paddle.com/subscription/cancel?user=12345&subscription=87654321&hash=eyJpdiI6IlU0Nk5cL1JZeHQyTXd...",
              "state": "active",
              "signup_date": "2015-10-06 09:44:23",
              "last_payment": {
                "amount": 5,
                "currency": "USD",
                "date": "2015-10-06"
              },
              "payment_information": {
                "payment_method": "card",
                "card_type": "visa",
                "last_four_digits": "1111",
                "expiry_date": "02/2020"
              },
              "quantity": 200,
              "next_payment": {
                "amount": 10,
                "currency": "USD",
                "date": "2015-11-06"
              }
            }
          ]
        }
      ))
    end)

    assert {:ok,
            [
              %Paddle.Subscription{
                subscription_id: 502_198,
                plan_id: 496_199,
                user_id: 285_846,
                user_email: "name@example.com",
                marketing_consent: true,
                update_url:
                  "https://checkout.paddle.com/subscription/update?user=12345&subscription=87654321&hash=eyJpdiI6Ik1RTE1nbHpXQmtJUG5...",
                cancel_url:
                  "https://checkout.paddle.com/subscription/cancel?user=12345&subscription=87654321&hash=eyJpdiI6IlU0Nk5cL1JZeHQyTXd...",
                state: "active",
                signup_date: ~U"2015-10-06 09:44:23Z",
                last_payment: %{
                  "amount" => 5,
                  "currency" => "USD",
                  "date" => ~D"2015-10-06"
                },
                payment_information: %{
                  "payment_method" => "card",
                  "card_type" => "visa",
                  "last_four_digits" => "1111",
                  "expiry_date" => "02/2020"
                },
                quantity: 200,
                next_payment: %{
                  "amount" => 10,
                  "currency" => "USD",
                  "date" => ~D"2015-11-06"
                }
              }
            ]} == Paddle.Subscription.list()
  end

  test "update user", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, ~s(
        {
          "success": true,
          "response": {
            "subscription_id": 12345,
            "user_id": 425123,
            "plan_id": 525123,
            "next_payment": {
              "amount": 144.06,
              "currency": "GBP",
              "date": "2018-02-15"
            }
          }
        }
      ))
    end)

    params = %{
      bill_immediately: true,
      plan_id: 525_123,
      quantity: 200,
      prorate: true,
      keep_modifiers: true,
      passthrough: true,
      pause: true
    }

    assert {:ok,
            %{
              subscription_id: 12_345,
              user_id: 425_123,
              plan_id: 525_123,
              next_payment: %{
                "amount" => 144.06,
                "currency" => "GBP",
                "date" => ~D"2018-02-15"
              }
            }} == Paddle.Subscription.update(12_345, params)
  end

  test "cancel_user", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, ~s(
        {
          "success": true
        }
      ))
    end)

    assert {:ok, nil} == Paddle.Subscription.cancel(12_345)
  end

  test "do not attempt to convert dates for nil values", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, ~s(
        {
          "success": true,
          "response": [
            {
              "subscription_id": 502198,
              "plan_id": 496199,
              "user_id": 285846,
              "user_email": "name@example.com",
              "marketing_consent": true,
              "update_url": "https://checkout.paddle.com/subscription/update?user=12345&subscription=87654321&hash=eyJpdiI6Ik1RTE1nbHpXQmtJUG5...",
              "cancel_url": "https://checkout.paddle.com/subscription/cancel?user=12345&subscription=87654321&hash=eyJpdiI6IlU0Nk5cL1JZeHQyTXd...",
              "state": "active",
              "signup_date": "2015-10-06 09:44:23",
              "last_payment": null,
              "payment_information": {
                "payment_method": "card",
                "card_type": "visa",
                "last_four_digits": "1111",
                "expiry_date": "02/2020"
              },
              "next_payment": null
            }
          ]
        }
      ))
    end)

    assert {:ok,
            [
              %Paddle.Subscription{
                subscription_id: 502_198,
                plan_id: 496_199,
                user_id: 285_846,
                user_email: "name@example.com",
                marketing_consent: true,
                update_url:
                  "https://checkout.paddle.com/subscription/update?user=12345&subscription=87654321&hash=eyJpdiI6Ik1RTE1nbHpXQmtJUG5...",
                cancel_url:
                  "https://checkout.paddle.com/subscription/cancel?user=12345&subscription=87654321&hash=eyJpdiI6IlU0Nk5cL1JZeHQyTXd...",
                state: "active",
                signup_date: ~U"2015-10-06 09:44:23Z",
                last_payment: nil,
                payment_information: %{
                  "payment_method" => "card",
                  "card_type" => "visa",
                  "last_four_digits" => "1111",
                  "expiry_date" => "02/2020"
                },
                next_payment: nil
              }
            ]} == Paddle.Subscription.list()
  end
end
