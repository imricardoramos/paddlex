defmodule Paddle.Subscription.Plan do
  @type t :: %{
    id: integer,
    name: atom,
    billing_type: String.t(),
    billing_period: integer,
    intial_price: number,
    recurring_price: number,
    trial_days: non_neg_integer(),
  }
  defstruct [
    :id,
    :name,
    :billing_type,
    :billing_period,
    :initial_price,
    :recurring_price,
    :trial_days
  ]
  @spec create(params) :: {:ok, integer} | {:error, Paddle.Error.t()}
    when params: %{
      :plan_name => String.t(),
      :plan_length => pos_integer,
      :plan_type => String.t(),
      optional(:plan_trial_days) => non_neg_integer,
      optional(:main_currency_code) => String.t(),
      optional(:recurring_price_usd) => String.t(),
      optional(:recurring_price_gbp) => String.t()
    }
  def create(params) do
    case Paddle.Request.post("/2.0/subscription/plans_create", params) do
      {:ok, result} -> {:ok, result["product_id"]}
      {:error, error} -> {:error, error}
    end
  end

  @spec list() :: {:ok, t} | {:error, Paddle.Error.t()}
  def list() do
    case Paddle.Request.post("/2.0/subscription/plans") do
      {:ok, list} -> {:ok, Enum.map(list, &Paddle.Helpers.map_to_struct(&1, __MODULE__))}
      {:error, reason} ->  {:error, reason}
    end
  end

end
