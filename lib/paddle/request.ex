defmodule Paddle.Request do
  @moduledoc """
  Low-level HTTP layer for the Paddle API.

  Requests are performed with `Req`. Both `post/3` and `get/3` accept an
  `opts` keyword list of per-call configuration overrides — see
  `Paddle.Config` for the supported keys.
  """

  @doc """
  Performs a POST request against the vendors API, merging the configured
  `vendor_id`/`vendor_auth_code` credentials into `params`.
  """
  @spec post(String.t(), map(), keyword()) :: {:ok, term()} | {:error, Paddle.Error.t()}
  def post(path, params \\ %{}, opts \\ []) do
    config = Paddle.Config.resolve(opts)

    with :ok <- validate_credentials(config) do
      credentials = %{vendor_id: config.vendor_id, vendor_auth_code: config.vendor_auth_code}

      Req.post(req(config.vendors_base_url <> path, opts),
        form: Map.merge(credentials, params)
      )
      |> handle_result()
    end
  end

  @doc """
  Performs a GET request against the checkout API.
  """
  @spec get(String.t(), map(), keyword()) :: {:ok, term()} | {:error, Paddle.Error.t()}
  def get(path, params \\ %{}, opts \\ []) do
    config = Paddle.Config.resolve(opts)

    Req.get(req(config.checkout_base_url <> path, opts), params: Map.to_list(params))
    |> handle_result()
  end

  defp req(url, opts) do
    Req.new(url: url, retry: false, decode_body: false)
    |> Req.merge(Keyword.get(opts, :req_options, []))
  end

  defp validate_credentials(%{vendor_id: vendor_id, vendor_auth_code: vendor_auth_code}) do
    if is_nil(vendor_id) or is_nil(vendor_auth_code) do
      {:error,
       %Paddle.Error{
         code: :missing_configuration,
         message:
           "missing :vendor_id and/or :vendor_auth_code — configure them under the " <>
             ":paddlex application or pass them as per-call options"
       }}
    else
      :ok
    end
  end

  defp handle_result({:ok, %Req.Response{body: body}}), do: parse_response_body(body)

  defp handle_result({:error, %Req.TransportError{} = error}) do
    {:error, %Paddle.Error{code: error.reason, message: Exception.message(error)}}
  end

  defp handle_result({:error, exception}) when is_exception(exception) do
    {:error, %Paddle.Error{code: :request_error, message: Exception.message(exception)}}
  end

  defp handle_result({:error, reason}), do: {:error, reason}

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
end
