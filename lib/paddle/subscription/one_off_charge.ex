defmodule Paddle.OneOffCharge do
  @type t :: %__MODULE__{
          invoice_id: integer,
          subscription_id: integer,
          amount: number,
          currency: String.t(),
          payment_date: Date.t(),
          receipt_url: String.t(),
          order_id: String.t()
        }
  defstruct [
    :invoice_id,
    :subscription_id,
    :amount,
    :currency,
    :payment_date,
    :receipt_url,
    :order_id
  ]

  @doc """
  Make an immediate one-off charge on top of an existing user subscription
  This feature is useful for scenarios where buyers need to purchase add-ons on top of a recurring plan.

  For example, Charges API provides you with the flexibility to charge buyers, with existing subscriptions, right away for one-off top-ups, rather than waiting for the end of their current billing cycle.

  ## Example

      Paddle.OneOffCharge.create(2746, 10, "TestCharge") 
      {:ok, %Paddle.OneOffCharge{
        invoice_id: 1,
        subscription_id: 1,
        amount: "10.00",
        currency: "USD",
        payment_date: ~D"2018-09-21",
        receipt_url: "https://my.paddle.com/receipt/1-1/3-chre8a53a2724c6-42781cb91a"
      }}
  """
  @spec create(integer, number, String.t()) :: {:ok, t} | {:error, Paddle.Error.t()}
  def create(subscription_id, amount, charge_name) do
    params = %{amount: amount, charge_name: charge_name}

    case Paddle.Request.post("/2.0/subscription/#{subscription_id}/charge", params) do
      {:ok, one_off_charge} ->
        {:ok,
         Paddle.Helpers.map_to_struct(one_off_charge, __MODULE__)
         |> Map.update!(:payment_date, &Date.from_iso8601!/1)}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
