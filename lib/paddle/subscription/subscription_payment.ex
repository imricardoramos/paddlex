defmodule Paddle.SubscriptionPayment do
  @moduledoc """
  SubscriptionPayment
  """
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

  @doc """
  List all paid and upcoming (unpaid) payments

  ## Examples

      Paddle.SubscriptionPayment.list() 
      {:ok, [%Paddle.SubscriptionPayment{
        id: 8936,
        subscription_id: 2746,
        amount: 1,
        currency: "USD",
        payout_date: "2015-10-15",
        is_paid: 0,
        is_one_off_charge: 0,
        receipt_url: "https://www.paddle.com/receipt/469214-8936/1940881-chrea0eb34164b5-f0d6553bdf"
      }]}
  """
  @spec list(list_args) :: {:ok, [t()]} | {:error, Paddle.Error.t()}
  def list(_opts \\ []) do
    case Paddle.Request.post("/2.0/subscription/payments") do
      {:ok, list} -> {:ok, Enum.map(list, &Paddle.Helpers.map_to_struct(&1, __MODULE__))}
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Change the due date of the upcoming subscription payment

  Note: You may need to first call `Paddle.SubscriptionPayment.list/1` to obtain an upcoming (unpaid) payment ID value to make this call.

  ## Examples

      Paddle.SubscriptionPayment.reschedule(10, ~D[2015-10-15])
      {:ok, nil}
  """
  @spec reschedule(integer, Date.t()) :: {:ok, nil} | {:error, Paddle.Error.t()}
  def reschedule(payment_id, date) do
    params = %{payment_id: payment_id, date: Date.to_string(date)}
    Paddle.Request.post("/2.0/subscription/payments_reschedule", params)
  end
end
