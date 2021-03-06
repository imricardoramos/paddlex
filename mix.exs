defmodule Paddle.MixProject do
  use Mix.Project

  def project do
    [
      app: :paddlex,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      source_url: "https://github.com/imricardoramos/paddlex",
      homepage_url: "/",
      docs: [
        main: "readme",
        groups_for_modules: [
          Alert: [
            Paddle.Webhook
          ],
          Checkout: [
            Paddle.OrderDetails,
            Paddle.Price,
            Paddle.UserHistory
          ],
          Product: [
            Paddle.Coupon,
            Paddle.License,
            Paddle.PayLink,
            Paddle.Product,
            Paddle.ProductPayment,
            Paddle.Transaction
          ],
          Subscription: [
            Paddle.Subscriber,
            Paddle.Plan,
            Paddle.SubscriptionPayment,
            Paddle.OneOffCharge,
            Paddle.Modifier
          ]
        ],
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:peppermint, "~> 0.3.0"},
      {:castore, "~> 0.1.0"},
      {:jason, "~> 1.2"},
      {:bypass, "~> 2.1", only: [:test]},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false}
    ]
  end
end
