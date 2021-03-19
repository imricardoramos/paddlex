defmodule Paddle.Webhook do
  @type t :: %__MODULE__{
          id: integer,
          alert_name: String.t(),
          status: String.t(),
          created_at: String.t(),
          updated_at: String.t(),
          attempts: integer,
          fields: map,
          query_tail: String.t()
        }

  defstruct [
    :id,
    :alert_name,
    :status,
    :created_at,
    :updated_at,
    :attempts,
    :fields,
    :query_tail
  ]

  @doc """
  Retrieve past events and alerts that Paddle has sent to webhooks on your account

  Strongly recommended to utilize `query_head` and `query_tail` to limit your search to no more than any 24-hour period when calling this API. This ensures that the API response time remains quick and consistent as the amount of events/alerts build up over time.

      Paddle.Webhook.get_history() 
      {:ok, %{
        current_page: 1,
        total_pages: 46,
        alerts_per_page: 10,
        total_alerts: 460,
        query_head: ~U[2015-07-17 14:04:06Z],
        data: [
          %Paddle.Webhook{
            id: 22257,
            alert_name: "payment_refunded",
            status: "success",
            created_at: ~U[2015-07-17 14:04:05Z],
            updated_at: ~U[2015-08-14 13:28:19Z],
            attempts: 1,
            fields: %{
              "order_id" => 384920,
              "amount" => "100",
              "currency" => "USD",
              "email" => "xxxxx@xxxxx.com",
              "marketing_consent" => 1
            }
          }
        ]
      }}
  """
  @spec get_history(params) :: {:ok, t} | {:error, Paddle.Error.t()}
        when params: %{
               optional(:page) => integer,
               optional(:alerts_per_page) => String.t(),
               optional(:query_head) => String.t(),
               optional(:query_tail) => String.t()
             }
  def get_history(params \\ %{}) do
    case Paddle.Request.post("/2.0/alert/webhooks", params) do
      {:ok, response} ->
        {:ok,
         %{
           total_alerts: response["total_alerts"],
           total_pages: response["total_pages"],
           alerts_per_page: response["alerts_per_page"],
           current_page: response["current_page"],
           query_head: response["query_head"],
           data: convert_data(response["data"])
         }
         |> maybe_convert_date(:query_head)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp convert_data(data) do
    Enum.map(data, fn elm ->
      Paddle.Helpers.map_to_struct(elm, __MODULE__)
      |> maybe_convert_date(:created_at)
      |> maybe_convert_date(:updated_at)
    end)
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
