defmodule Paddle.Plan do
  @moduledoc """
  Plan
  """
  @type t :: %{
          id: integer,
          name: atom,
          billing_type: String.t(),
          billing_period: integer,
          intial_price: number,
          recurring_price: number,
          trial_days: non_neg_integer()
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

  @doc """
  Create a new subscription plan with the supplied parameters

  ## Examples

      params = %{
        main_currency_code: "USD",
        plan_length: 123,
        plan_name: "Test",
        plan_trial_days: "123",
        plan_type: "day",
        recurring_price_eur: "10.00",
        recurring_price_gbp: "20.00",
        recurring_price_usd: "30.00",
      }
      Paddle.Plan.create(params)
      {:ok, 502198}
  """
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

  @doc """
  List all of the available subscription plans in your account

  Optionally also accepts the parameter `plan_id` with the value of a Plan/Product ID, to return just the information related to that specific plan.

  ## Examples

      iex> Paddle.Plan.list() 
      {:ok, [
        %Paddle.Plan{
          billing_period: 1,
          billing_type: "day",
          id: 9636,
          initial_price: %{"USD" => "0.00"},
          name: "Test",
          recurring_price: %{"USD" => "10.00"},
          trial_days: 0
        }
      ]}
  """
  @spec list(keyword()) :: {:ok, [t]} | {:error, Paddle.Error.t()}
  def list(opts \\ []) do
    params =
      Enum.into(opts, %{})
      |> Map.take([:plan_id])
      |> rename_key(:plan_id, :plan)

    case Paddle.Request.post("/2.0/subscription/plans", params) do
      {:ok, list} -> {:ok, Enum.map(list, &Paddle.Helpers.map_to_struct(&1, __MODULE__))}
      {:error, reason} -> {:error, reason}
    end
  end

  defp rename_key(map, old_key, new_key) do
    {old_value, new_map} = Map.pop(map, old_key)

    if old_value do
      new_map
      |> Map.put(new_key, old_value)
    else
      map
    end
  end
end
