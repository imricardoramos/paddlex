defmodule Paddle.Subscription.Modifier do
  @type t :: %{
    modifier_id: integer,
    subscription_id: integer,
    amount: String.t(),
    currency: String.t(),
    is_recurring: boolean,
    description: String.t
  }
  defstruct [:modifier_id, :subscription_id, :amount, :currency, :is_recurring, :description]

  # TODO: add parameters for filtering list
  @spec list() :: {:ok, [t()]} | {:error, Paddle.Error.t()}
  def list() do
    case Paddle.Request.post("/2.0/subscription/modifiers") do
      {:ok, list} -> {:ok, Enum.map(list, &Paddle.Helpers.map_to_struct(&1, __MODULE__) )}
      {:error, reason} -> {:error, reason}
    end
  end

  @spec create(params) :: {:ok, map} | {:error, Paddle.Error.t()}
    when params: %{
      :subscription_id => integer,
      :modifier_recurring => boolean,
      :modifier_amount => number,
      :modifier_description => String.t()
    }
  def create(params) do
    case Paddle.Request.post("/2.0/subscription/modifiers/create", params) do
      {:ok, modifier} -> {:ok, %{
          subscription_id: modifier["subscription_id"],
          modifier_id: modifier["modifier_id"],
      }}
      {:error, reason} -> {:error, reason}
    end
  end

  @spec delete(integer) :: {:ok, nil} | {:error, Paddle.Error.t()}
  def delete(modifier_id) do
    Paddle.Request.post("/2.0/subscription/modifiers/delete", %{modifier_id: modifier_id})
  end
end
