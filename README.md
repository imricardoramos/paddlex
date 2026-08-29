# Paddlex

An Elixir wrapper for the paddle.com API, inspired by [paddle_pay](https://github.com/devmindo/paddle_pay) and [stripity_stripe](https://github.com/code-corps/stripity_stripe)

[![Hex.pm](https://img.shields.io/hexpm/v/paddlex)](https://hex.pm/packages/paddlex)
[![Hex.pm](https://img.shields.io/badge/hex-docs-blue)](https://hexdocs.pm/paddlex) 
![Hex.pm](https://img.shields.io/hexpm/dt/paddlex)
[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/imricardoramos/paddlex/ci?label=ci&logo=github)](https://github.com/imricardoramos/paddlex/actions)

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Installation

Add `paddlex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:paddlex, "~> 0.2.0"}
  ]
end
```

## Usage

### Configuration

Configure the library with the credentials obtained from the Paddle Dashboard:

```elixir
# config/dev.exs
config :paddlex,
  environment: :sandbox,
  vendor_id: 12345,
  vendor_auth_code: "YOUR SANDBOX VENDOR AUTH CODE"
```

```elixir
# config/prod.exs
config :paddlex,
  environment: :production, # the default
  vendor_id: 12345,
  vendor_auth_code: "YOUR PRODUCTION VENDOR AUTH CODE"
```

Every API function also accepts a trailing keyword list to override
configuration per call — useful for multi-tenant apps or tests:

```elixir
Paddle.Product.list(vendor_id: 67890, vendor_auth_code: "...")
Paddle.Coupon.create(params, vendors_base_url: "http://localhost:4001/api")
```

Supported override keys: `:vendor_id`, `:vendor_auth_code`, `:environment`,
`:vendors_base_url`, `:checkout_base_url`, and `:req_options` (merged into the
underlying [Req](https://hexdocs.pm/req) request).

### Examples

For examples of usage, please see the [HexDocs](https://hexdocs.pm/paddlex) 

## Contributing

Feedback, feature requests, and fixes are welcomed and encouraged.

To ensure a commit passes CI you should run `mix check`

## License

Paddlex is released under the MIT license. See the [LICENSE](https://github.com/imricardoramos/paddlex/blob/master/LICENSE.txt).
