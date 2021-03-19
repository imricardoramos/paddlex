defmodule Paddle.Modifier do
  @type t :: %{
          modifier_id: integer,
          subscription_id: integer,
          amount: String.t(),
          currency: String.t(),
          is_recurring: boolean,
          description: String.t()
        }
  defstruct [:modifier_id, :subscription_id, :amount, :currency, :is_recurring, :description]

  # TODO: add parameters for filtering list
  @doc """
  List all subscription modifiers

  Optionally, the query accepts the parameter plan_id with the value of a Plan/Product ID, to list all the subscriptions modifiers of a certain plan. It also accepts subscription_id to get modifiers applied to a specific subscription plan.

  ## Examples

      Paddle.Modifier.list() 
      {:ok, [%Paddle.Modifier{
        modifier_id: 10,
        subscription_id: 12345,
        amount: "1.000",
        currency: "USD",
        is_recurring: false,
        description: "Example Modifier"
      }]}

  """
  @spec list() :: {:ok, [t()]} | {:error, Paddle.Error.t()}
  def list() do
    case Paddle.Request.post("/2.0/subscription/modifiers") do
      {:ok, list} -> {:ok, Enum.map(list, &Paddle.Helpers.map_to_struct(&1, __MODULE__))}
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Create a subscription modifier to dynamically change the subscription payment amount

  A modifier applied to a recurring subscription increases or decreases the next payment by a flat amount (in the currency of the subscription). The modifier itself may recur and apply to all future payments until it is removed.

  ## Examples
      
      Paddle.Modifier.create(params) 
      params = %{
        subscription_id: 12345,
        modifier_recurring: true,
        modifier_amount: 20,
        modifier_description: "TestModifier"
      }
      {:ok, %{
        subscription_id: 12345,
        modifier_id: 10
      }}
  """
  @spec create(params) :: {:ok, map} | {:error, Paddle.Error.t()}
        when params: %{
               :subscription_id => integer,
               :modifier_recurring => boolean,
               :modifier_amount => number,
               :modifier_description => String.t()
             }
  def create(params) do
    case Paddle.Request.post("/2.0/subscription/modifiers/create", params) do
      {:ok, modifier} ->
        {:ok,
         %{
           subscription_id: modifier["subscription_id"],
           modifier_id: modifier["modifier_id"]
         }}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Delete an existing subscription modifier

  ## Examples

      Paddle.Modifier.delete(10)
      {:ok, nil}
  """
  @spec delete(integer) :: {:ok, nil} | {:error, Paddle.Error.t()}
  def delete(modifier_id) do
    Paddle.Request.post("/2.0/subscription/modifiers/delete", %{modifier_id: modifier_id})
  end
end
