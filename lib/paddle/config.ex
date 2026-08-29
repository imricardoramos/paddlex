defmodule Paddle.Config do
  @moduledoc """
  Resolves library configuration.

  Configuration is read from the `:paddlex` application environment and can be
  overridden per call via the `opts` keyword list accepted by every API
  function:

      config :paddlex,
        vendor_id: 12345,
        vendor_auth_code: "...",
        environment: :sandbox # or :production (default)

  Supported keys:

    * `:vendor_id` - your Paddle vendor id
    * `:vendor_auth_code` - your Paddle API auth code
    * `:environment` - `:production` (default) or `:sandbox`
    * `:vendors_base_url` - overrides the vendors API base URL
    * `:checkout_base_url` - overrides the checkout API base URL
  """

  @type t :: %{
          vendor_id: integer() | String.t() | nil,
          vendor_auth_code: String.t() | nil,
          environment: atom(),
          vendors_base_url: String.t(),
          checkout_base_url: String.t()
        }

  @config_keys [
    :vendor_id,
    :vendor_auth_code,
    :environment,
    :vendors_base_url,
    :checkout_base_url
  ]

  @doc """
  Resolves the effective configuration, merging per-call `overrides` over the
  application environment. Keys other than the supported ones are ignored.
  """
  @spec resolve(keyword()) :: t()
  def resolve(overrides \\ []) do
    environment =
      Keyword.get(
        overrides,
        :environment,
        Application.get_env(:paddlex, :environment, :production)
      )

    %{
      vendor_id: Application.get_env(:paddlex, :vendor_id),
      vendor_auth_code: Application.get_env(:paddlex, :vendor_auth_code),
      environment: environment,
      vendors_base_url:
        Application.get_env(:paddlex, :vendors_base_url, default_vendors_base_url(environment)),
      checkout_base_url:
        Application.get_env(:paddlex, :checkout_base_url, default_checkout_base_url(environment))
    }
    |> Map.merge(overrides |> Keyword.take(@config_keys) |> Map.new())
  end

  defp default_vendors_base_url(:sandbox), do: "https://sandbox-vendors.paddle.com/api"
  defp default_vendors_base_url(_), do: "https://vendors.paddle.com/api"

  defp default_checkout_base_url(:sandbox), do: "https://sandbox-checkout.paddle.com/api"
  defp default_checkout_base_url(_), do: "https://checkout.paddle.com/api"
end
