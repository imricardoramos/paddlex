defmodule Paddle do
  @moduledoc """
  An Elixir client for the [Paddle Classic API](https://developer.paddle.com/classic/api-reference).

  ## Configuration

      config :paddlex,
        vendor_id: 12345,
        vendor_auth_code: "YOUR_AUTH_CODE",
        environment: :sandbox # or :production (default)

  All configuration can also be overridden per call by passing a trailing
  keyword list to any API function:

      Paddle.Product.list(vendor_id: 67890, vendor_auth_code: "OTHER_CODE")

  See `Paddle.Config` for the full list of supported keys.

  ## Usage

  Each Paddle resource has its own module, e.g. `Paddle.Subscription`,
  `Paddle.Product`, `Paddle.Coupon`. Functions return `{:ok, result}` or
  `{:error, %Paddle.Error{}}`.
  """
end
