defmodule Paddle.Request do
  @moduledoc """
  Request
  """

  @doc """
  Creates a new request
  """
  def post(path, params \\ %{}) do
    url = vendors_base_url() <> path
    config = Paddle.Config.resolve() |> Map.take([:vendor_id, :vendor_auth_code])
    params = Map.merge(config, params)

    request =
      Peppermint.post(
        url,
        params: params,
        headers: [{"Content-Type", "application/x-www-form-urlencoded"}]
      )

    case request do
      {:ok, response} ->
        parse_response_body(response.body)

      {:error, reason} ->
        {:error, reason}
    end
  end

  def get(path, params \\ %{}) do
    url = checkout_base_url() <> path

    case Peppermint.get(url, params: params) do
      {:ok, response} ->
        parse_response_body(response.body)

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp parse_response_body(request_body) do
    body = Jason.decode!(request_body)

    case body do
      %{"success" => true, "response" => response} -> {:ok, response}
      %{"success" => true, "message" => message} -> {:ok, message}
      %{"success" => true} -> {:ok, nil}
      %{"success" => false} -> {:error, parse_api_error(body["error"])}
      _ -> body
    end
  end

  defp parse_api_error(error) do
    %Paddle.Error{
      code: error["code"],
      message: error["message"]
    }
  end

  defp vendors_base_url do
    case Paddle.Config.resolve() do
      %{environment: :production} -> "https://vendors.paddle.com/api"
      %{environment: :sandbox} -> "https://sandbox-vendors.paddle.com/api"
      %{environment: :test} -> "http://localhost:12345/api"
    end
  end

  defp checkout_base_url do
    case Paddle.Config.resolve() do
      %{environment: :production} -> "https://checkout.paddle.com/api"
      %{environment: :sandbox} -> "https://sandbox-checkout.paddle.com/api"
      %{environment: :test} -> "http://localhost:12345/api"
    end
  end
end
