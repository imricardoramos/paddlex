defmodule Paddle.Product.Payment do

  @spec refund(String.t(), map) :: {:ok, integer} | {:error, Paddle.Error.t()}
  def refund(order_id, params \\ %{}) do
    params = Map.merge(params, %{order_id: order_id})
    case Paddle.Request.post("/2.0/payment/refund", params) do
      {:ok, response} -> {:ok, response["refund_request_id"]}
      {:error, reason} -> {:error, reason}
    end
  end
end
