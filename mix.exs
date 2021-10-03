defmodule Paddle.MixProject do
  use Mix.Project

  def project do
    [
      app: :paddlex,
      version: "0.1.1",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),

      # Docs
      source_url: "https://github.com/imricardoramos/paddlex",
      homepage_url: "/",
      docs: [
        main: "readme",
        groups_for_modules: groups_for_modules(),
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
      {:credo, "~> 1.5.6", only: [:dev, :test], runtime: false},
      {:jason, "~> 1.2"},
      {:bypass, "~> 2.1", only: [:test]},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:ex_check, "~> 0.14.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.24", only: [:dev, :test], runtime: false}
    ]
  end

  defp description do
    """
    A Paddle client for Elixir.
    """
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/imricardoramos/paddlex"
      },
      maintainers: ["Ricardo Ramos"]
    ]
  end

  defp groups_for_modules do
    [
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
        Paddle.Subscription,
        Paddle.Plan,
        Paddle.SubscriptionPayment,
        Paddle.OneOffCharge,
        Paddle.Modifier
      ]
    ]
  end
end
