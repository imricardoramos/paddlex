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

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `paddle` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:paddlex, "~> 0.1.0"}
  ]
end
```

## Usage

### Configuration

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

## Contributing

Feedback, feature requests, and fixes are welcomed and encouraged.
Here are a few things this package is missing:

- Write tests and reach 100% code coverage.
- Ensure dialyzer signatures are correct
- Pick a suitable HTTP client (see [here](https://elixirforum.com/t/http-client-libraries-and-wrappers/15938) and [here](https://elixirforum.com/t/mint-vs-finch-vs-gun-vs-tesla-vs-httpoison-etc/38588))
- Improve docs

To ensure a commit passes CI you should run `mix check`

## License

Paddlex is released under the MIT license. See the [LICENSE](https://github.com/imricardoramos/paddlex/blob/master/LICENSE.txt).
