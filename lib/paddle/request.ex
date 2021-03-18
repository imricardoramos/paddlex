defmodule Paddle.Request do

  @doc """
  Creates a new request
  """
  def post(path, params \\ %{}) do
    url = base_url() <> path
    config = Paddle.Config.resolve() |> Map.take([:vendor_id, :vendor_auth_code])
    params = Map.merge(config, params)
    # IO.inspect(url, label: "url")
    # IO.inspect(params, label: "params")

    request = Peppermint.post(
      url,
      params: params,
      headers: [{"Content-Type", "application/x-www-form-urlencoded"}])

    case request do
      {:ok, response} -> 
        #IO.inspect(response, label: "response")
        parse_response_body(response.body)
      {:error, reason} ->
        #IO.inspect(reason, label: "reason")
        {:error, reason}
    end
  end

  def get(path, params \\ %{}) do
    url = base_url() <> path

    case Peppermint.get(url, params: params) do
      {:ok, response} -> 
        #IO.inspect(response, label: "response")
        parse_response_body(response.body)
      {:error, reason} ->
        #IO.inspect(reason, label: "reason")
        {:error, reason}
    end
  end

  defp parse_response_body(request_body) do
    body = Jason.decode!(request_body)
    IO.inspect(body)
    case body do
      %{"success" => true, "response" => response} -> {:ok, response}
      %{"success" => true} -> {:ok, nil}
      %{"success" => false} -> {:error, parse_api_error(body["error"])}
    end
  end

  defp parse_api_error(error) do
    %Paddle.Error{
      code: error["code"],
      message: error["message"]
    }
  end

  defp base_url do
    case Paddle.Config.resolve() do
      %{environment: :production} -> "https://vendors.paddle.com/api"
      %{environment: :sandbox} -> "https://sandbox-vendors.paddle.com/api"
      %{environment: :test} -> "http://localhost:12345/api"
    end
  end
end
