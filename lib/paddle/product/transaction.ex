defmodule Paddle.Product.Transaction do

  @type t :: %__MODULE__{
    order_id: String.t(),
    checkout_id: String.t(),
    amount: String.t(),
    currency: String.t(),
    status: String.t(),
    created_at: String.t(),
    passthrough: String.t(),
    product_id: integer,
    is_subscription: boolean,
    is_one_off: boolean,
    subscription: map,
    user: map,
    receipt_url: String.t()
  }

  defstruct [
    :order_id,
    :checkout_id,
    :amount,
    :currency,
    :status,
    :created_at,
    :passthrough,
    :product_id,
    :is_subscription,
    :is_one_off,
    :subscription,
    :user,
    :receipt_url
  ]

  @spec list(String.t(), String.t()) :: {:ok, t} | {:error, Paddle.Error.t()}
  def list(entity, id) do
    case Paddle.Request.post("/2.0/#{entity}/#{id}/transactions") do
      {:ok, list} -> {:ok,
          Enum.map(list, fn elm ->
            Paddle.Helpers.map_to_struct(elm, __MODULE__)
            |> maybe_convert_date(:created_at)
          end)
      }
      {:error, reason} -> {:error, reason}
    end
  end

  defp maybe_convert_date(map, key) do
    datetime_string = Map.get(map,key)
    if datetime_string do
      {:ok, datetime, 0} = DateTime.from_iso8601(datetime_string  <> "Z")
      Map.replace(map, key, datetime)
    else
      map
    end
  end
end
