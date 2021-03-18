defmodule Paddle.Subscription.User do
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
    payment_information: Paddle.Payments.CardPayment.t | Paddle.Payments.PaypalPayment.t
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
  ]
  
  @spec list() :: {:ok, t} | {:error, Paddle.Error.t()}
  def list() do
    case Paddle.Request.post("/2.0/subscription/users") do
      {:ok, list} -> {:ok, Enum.map(list, fn elm -> 
          Paddle.Helpers.map_to_struct(elm, __MODULE__)
          |> convert_dates()
      end)}
      {:error, reason} ->  {:error, reason}
    end
  end

  @spec update(integer, params) :: {:ok, map} | {:error, Paddle.Error.t()}
    when params: %{
      :quantity => integer,
      optional(:currency) => String.t(),
      optional(:recurring_price) => number,
      optional(:bill_immediately) => boolean,
      optional(:plan_id) => integer,
      optional(:prorate) => boolean,
      optional(:keep_modifiers) => boolean,
      optional(:passthrough) => String.t(),
      optional(:pause) => boolean,
    }
  def update(subscription_id, params) do
    params = Map.put(params, :subscription_id, subscription_id)
    case Paddle.Request.post("/2.0/subscription/users/update", params) do
      {:ok, user} ->   
          user = %{
            subscription_id: user["subscription_id"],
            user_id:  user["user_id"],
            plan_id: user["plan_id"],
            next_payment: user["next_payment"]
          }
          user = put_in(user, [:next_payment, "date"], Date.from_iso8601!(user.next_payment["date"]))
        {:ok, user}
      {:error, reason} ->  {:error, reason}
    end
  end

  @spec cancel(integer) :: {:ok, nil}, {:error, Paddle.Error.t()}
  def cancel(subscription_id) do
    Paddle.Request.post("/2.0/subscription/users/cancel", %{subscription_id: subscription_id})
  end

  defp convert_dates(user) do
    user = put_in(user.last_payment["date"], Date.from_iso8601!(user.last_payment["date"]))
    user = put_in(user.next_payment["date"], Date.from_iso8601!(user.next_payment["date"]))
    {:ok, signup_datetime, 0} = DateTime.from_iso8601(user.signup_date <> "Z")
    put_in(user.signup_date, signup_datetime)
  end

end
