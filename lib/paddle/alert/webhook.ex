defmodule Paddle.Alert.Webhook do
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
    :query_tail,
  ]

  @spec get_history(params) :: {:ok, t} | {:error, Paddle.Error.t()}
    when params: %{
      optional(:page) => integer,
      optional(:alerts_per_page) => String.t(),
      optional(:query_head) => String.t(),
      optional(:query_tail) => String.t(),
    }
  def get_history(params \\ %{}) do
    case Paddle.Request.post("/2.0/alert/webhooks", params) do
      {:ok, response} -> {:ok, %{
          total_alerts: response["total_alerts"],
          total_pages: response["total_pages"],
          alerts_per_page: response["alerts_per_page"],
          current_page: response["current_page"],
          query_head: response["query_head"],
          data: convert_data(response["data"]),
      } |> maybe_convert_date(:query_head)}
      {:error, reason} -> {:error, reason}
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
    datetime_string = Map.get(map,key)
    if datetime_string do
      {:ok, datetime, 0} = DateTime.from_iso8601(datetime_string  <> "Z")
      Map.replace(map, key, datetime)
    else
      map
    end
  end

end
