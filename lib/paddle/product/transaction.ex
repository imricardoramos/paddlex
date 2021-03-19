defmodule Paddle.Transaction do
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

  @doc """
  Retrieve transactions for related entities within Paddle
  Transaction data can be retrieved using a User ID, Subscription ID, Order ID, Checkout ID (hash) or Product ID.

      params = %{
        product_id: 1234,
        allowed_uses: 10,
        expires_at: ~D[2018-10-10]
      }
      Paddle.Transaction.list("user", 29777)
      {:ok, [
        %Paddle.Transaction{
          order_id: "1042907-384786",
          checkout_id: "4795118-chre895f5cfaf61-4d7dafa9df",
          amount: "5.00",
          currency: "USD",
          status: "completed",
          created_at: ~U[2017-01-22 00:38:43Z],
          passthrough: nil,
          product_id: 12345,
          is_subscription: true,
          is_one_off: false,
          subscription: %{
            "subscription_id" => 123456,
            "status" => "active"
          },
          user: %{
            "user_id" => 29777,
            "email" => "example@paddle.com",
            "marketing_consent" => true
          },
          receipt_url: "https://my.paddle.com/receipt/1042907-384786/4795118-chre895f5cfaf61-4d7dafa9df"
        },
        %Paddle.Transaction{
          order_id: "1042907-384785",
          checkout_id: "4795118-chre895f5cfaf61-4d7dafa9df",
          amount: "5.00",
          currency: "USD",
          status: "refunded",
          created_at: ~U[2016-12-07 12:25:09Z],
          passthrough: nil,
          product_id: 12345,
          is_subscription: true,
          is_one_off: true,
          subscription: %{
           "subscription_id" => 123456,
            "status" => "active"
          },
          user: %{
            "user_id" => 29777,
            "email" => "example@paddle.com",
            "marketing_consent" => true
          },
          receipt_url: "https://my.paddle.com/receipt/1042907-384785/4795118-chre895f5cfaf61-4d7dafa9df"
        }
      ]}
  """
  @spec list(String.t(), String.t()) :: {:ok, t} | {:error, Paddle.Error.t()}
  def list(entity, id) do
    case Paddle.Request.post("/2.0/#{entity}/#{id}/transactions") do
      {:ok, list} ->
        {:ok,
         Enum.map(list, fn elm ->
           Paddle.Helpers.map_to_struct(elm, __MODULE__)
           |> maybe_convert_date(:created_at)
         end)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp maybe_convert_date(map, key) do
    datetime_string = Map.get(map, key)

    if datetime_string do
      {:ok, datetime, 0} = DateTime.from_iso8601(datetime_string <> "Z")
      Map.replace(map, key, datetime)
    else
      map
    end
  end
end
