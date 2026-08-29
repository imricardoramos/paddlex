defmodule Paddle.MixProject do
  use Mix.Project

  def project do
    [
      app: :paddlex,
      version: "0.2.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      elixirc_paths: elixirc_paths(Mix.env()),
      dialyzer: [
        plt_add_apps: [:ex_unit],
        plt_local_path: "priv/plts"
      ],

      # Docs
      source_url: "https://github.com/imricardoramos/paddlex",
      homepage_url: "https://github.com/imricardoramos/paddlex",
      docs: [
        main: "readme",
        groups_for_modules: groups_for_modules(),
        extras: ["README.md", "CHANGELOG.md"]
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
      {:req, "~> 0.5"},
      {:jason, "~> 1.4"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:bypass, "~> 2.1", only: [:test]},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:ex_check, "~> 0.16", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.34", only: [:dev, :test], runtime: false}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

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
