defmodule Paddle.Subscription.OneOffCharge do
  @type t :: %__MODULE__{
    invoice_id: integer,
    subscription_id: integer,
    amount: number,
    currency: String.t(),
    payment_date: Date.t(),
    receipt_url: String.t(),
    order_id: String.t(),
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

  @spec create(integer, number, String.t()) :: {:ok, t} | {:error, Paddle.Error.t()}  
  def create(subscription_id, amount, charge_name) do
    params = %{amount: amount, charge_name: charge_name}
    case Paddle.Request.post("/2.0/subscription/#{subscription_id}/charge", params) do
      {:ok, one_off_charge} -> {:ok,
          Paddle.Helpers.map_to_struct(one_off_charge, __MODULE__)
          |> Map.update!(:payment_date, &Date.from_iso8601!/1)
      }
      {:error, reason} ->  {:error, reason}
    end
  end

end
