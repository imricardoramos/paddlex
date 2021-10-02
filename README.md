# Paddlex

An Elixir wrapper for the paddle.com API, inspired by [paddle_pay](https://github.com/devmindo/paddle_pay) and [stripity_stripe](https://github.com/code-corps/stripity_stripe)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `paddle` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:paddlex, "~> 0.1.0"}
  ]
end
```

## Configuration

Configure lib the credentials obtained from the Paddle Dashboard

```
# config/dev.exs
config :paddlex,
  environment: :sandbox
  vendor_id: "YOUR SANBOX VENDOR ID (as number)"
  vendor_auth_code: 'YOUR SANDBOX VENDOR AUTH CODE'
```

```
# config/prod.exs
config :paddlex,
  environment: :production
  vendor_id: "YOUR PRODUCTION VENDOR ID (as number)"
  vendor_auth_code: 'YOUR PRODUCTION VENDOR AUTH CODE'
```

## License

Paddlex is released under the MIT license. See the [LICENSE](LICENSE.txt).
