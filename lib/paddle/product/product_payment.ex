defmodule Paddle.ProductPayment do
  @doc """
  Request a refund for a one-time or subscription payment, either in full or partial

  Note that refunds are not immediate and will be reviewed and approved by our buyer support team.

  ## Examples
    
      Paddle.ProductPayment.refund(10)
      {:ok, 12345}
  """
  @spec refund(String.t(), map) :: {:ok, integer} | {:error, Paddle.Error.t()}
  def refund(order_id, params \\ %{}) do
    params = Map.merge(params, %{order_id: order_id})

    case Paddle.Request.post("/2.0/payment/refund", params) do
      {:ok, response} -> {:ok, response["refund_request_id"]}
      {:error, reason} -> {:error, reason}
    end
  end
end
