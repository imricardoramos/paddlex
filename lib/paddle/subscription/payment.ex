defmodule Paddle.Subscription.Payment do
  @type t :: %__MODULE__{
    id: integer,
    subscription_id: integer,
    amount: integer,
    currency: String.t(),
    payout_date: String.t(),
    is_paid: boolean,
    receipt_url: String.t(),
    is_one_off_charge: boolean
  }
  defstruct [
    :id,
    :subscription_id,
    :amount,
    :currency,
    :payout_date,
    :is_paid,
    :receipt_url,
    :is_one_off_charge
  ]

  @type list_args :: [
    plan: integer,
    is_paid: boolean,
    from: String.t(),
    to: String.t(),
    is_one_off_charge: boolean
  ]

  @spec list(list_args) :: {:ok, [t()]} | {:error, Paddle.Error.t()}
  def list(params \\ []) do
    case Paddle.Request.post("/2.0/subscription/payments") do
      {:ok, list} -> {:ok, Enum.map(list, &Paddle.Helpers.map_to_struct(&1, __MODULE__))}
      {:error, reason} ->  {:error, reason}
    end
  end

  @spec reschedule(integer, Date.t()) :: {:ok, nil} | {:error, Paddle.Error.t()} 
  def reschedule(payment_id, date) do
    params = %{payment_id: payment_id, date: Date.to_string(date)}
    Paddle.Request.post("/2.0/subscription/payments_reschedule", params)
  end

end
