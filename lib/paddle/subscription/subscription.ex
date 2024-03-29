defmodule Paddle.Subscription do
  @moduledoc """
  This module corresponds to the `subscription/users` endpoint in the Paddle API,
  I've changed the name to Subscription as I found it to be more accurate.
  """

  @type t :: %{
          subscription_id: integer,
          plan_id: integer,
          user_id: integer,
          user_email: String.t(),
          marketing_consent: boolean,
          state: String.t(),
          signup_date: String.t(),
          last_payment: map,
          next_payment: map | nil,
          update_url: String.t(),
          cancel_url: String.t(),
          paused_at: String.t() | nil,
          paused_from: String.t() | nil,
          payment_information: map,
          quantity: integer
        }
  defstruct [
    :subscription_id,
    :plan_id,
    :user_id,
    :user_email,
    :marketing_consent,
    :state,
    :signup_date,
    :last_payment,
    :next_payment,
    :update_url,
    :cancel_url,
    :paused_at,
    :paused_from,
    :payment_information,
    :quantity
  ]

  @doc """
  List all users subscribed to any of your subscription plans

  Optionally also accepts `plan_id`, `subscription_id`, and `state` to filter the response to just users of a specific plan, a user subscription, or the status of the user’s subscription.

  If not filtering by the `subscription_id`, it is strongly recommend to utilize `results_per_page` and `page` to limit the amount of results returned within each API call. This ensures that the response time remains quick and consistent as the amount of user subscriptions build up over time.

  ## Examples

      Paddle.Subscription.list()
      {:ok, [
        %Paddle.Subscription{
          subscription_id: 502198,
          plan_id: 496199,
          user_id: 285846,
          user_email: "name@example.com",
          marketing_consent: true,
          update_url: "https://checkout.paddle.com/subscription/update?user=12345&subscription=87654321&hash=eyJpdiI6Ik1RTE1nbHpXQmtJUG5...",
          cancel_url: "https://checkout.paddle.com/subscription/cancel?user=12345&subscription=87654321&hash=eyJpdiI6IlU0Nk5cL1JZeHQyTXd...",
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
      ]}
  """
  @spec list(keyword()) ::
          {:ok, [t()]} | {:error, Paddle.Error.t()}
  def list(opts \\ []) do
    params =
      Enum.into(opts, %{})
      |> Map.take([:subscription_id, :plan_id, :state, :page, :results_per_page])

    case Paddle.Request.post("/2.0/subscription/users", params) do
      {:ok, list} ->
        {:ok,
         Enum.map(list, fn elm ->
           Paddle.Helpers.map_to_struct(elm, __MODULE__)
           |> convert_dates()
         end)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Update the quantity, price, and/or plan of a user’s subscription

  ## Usage Notes

    - Subscribers on non-quantity plans can move to quantity plans but not the inverse.
    - Subscribers must be billed immediately when moving to a plan with a different billing interval.
    - Subscribers cannot be moved to a plan where the current currency is not enabled.
    - Subscribers cannot be moved to a different plan while on a trialing state.
    - Subscribers in a paused state cannot be modified until they restart their subscription.
    - Subscribers in a past due state can only have the passthrough or pause field updated.
    - The currency of an existing subscription cannot be changed.
    - Recurring coupons (if present) will be removed when this API is used.

  ## Examples

      params = %{
        bill_immediately: true,
        plan_id: 525123,
        quantity: 200,
        prorate: true,
        keep_modifiers: true,
        passthrough: true,
        pause: true
      }
      Paddle.Subscription.update(12345, params)
      {:ok, %{
        subscription_id: 12345,
        user_id: 425123,
        plan_id: 525123,
        quantity: 200,
        next_payment: %{
          "amount" => 144.06,
          "currency" => "GBP",
          "date" => ~D"2018-02-15",
        }
      }}
  """
  @spec update(integer, params) :: {:ok, map} | {:error, Paddle.Error.t()}
        when params: %{
               optional(:currency) => String.t(),
               optional(:recurring_price) => number,
               optional(:bill_immediately) => boolean,
               optional(:plan_id) => integer,
               optional(:quantity) => integer,
               optional(:prorate) => boolean,
               optional(:keep_modifiers) => boolean,
               optional(:passthrough) => String.t(),
               optional(:pause) => boolean
             }
  def update(subscription_id, params) do
    params = Map.put(params, :subscription_id, subscription_id)

    case Paddle.Request.post("/2.0/subscription/users/update", params) do
      {:ok, user} ->
        user = %{
          subscription_id: user["subscription_id"],
          user_id: user["user_id"],
          plan_id: user["plan_id"],
          next_payment: user["next_payment"]
        }

        user =
          put_in(user, [:next_payment, "date"], Date.from_iso8601!(user.next_payment["date"]))

        {:ok, user}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Cancel the specified user’s subscription

  ## Examples

      Paddle.Subscription.cancel(12345)
      {:ok, nil}
  """
  @spec(cancel(integer) :: {:ok, nil}, {:error, Paddle.Error.t()})
  def cancel(subscription_id) do
    Paddle.Request.post("/2.0/subscription/users/cancel", %{subscription_id: subscription_id})
  end

  defp convert_dates(user) do
    last_payment =
      user.last_payment &&
        Map.update!(user.last_payment, "date", fn date -> Date.from_iso8601!(date) end)

    next_payment =
      user.next_payment &&
        Map.update!(user.next_payment, "date", fn date -> Date.from_iso8601!(date) end)

    {:ok, signup_datetime, 0} = DateTime.from_iso8601(user.signup_date <> "Z")
    %{user | last_payment: last_payment, next_payment: next_payment, signup_date: signup_datetime}
  end
end
