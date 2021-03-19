defmodule Paddle.UserHistory do
  @doc """
  Send the customer an order history and license recovery email

  A customer may wish to have their past purchases or license details confirmed. For example, when they have changed computers. This API will send an email to the customer detailing this.

  The API will always return a success response for all valid email addresses, even if they have not had any orders previously (buyers will receive an email stating that no orders were found).

  ## Examples
    
      Paddle.UserHistory.get("user@example.com", vendor_id: 1234)
      {:ok, "We've sent details of your past transactions, licenses and downloads to you via email."} 

  """
  @spec get(String.t(), vendor_id: integer, product_id: integer) ::
          {:ok, String.t()} | {:error, Paddle.Error.t()}
  def get(email, opts \\ []) do
    params =
      %{
        email: email,
        vendor_id: opts[:vendor_id],
        product_id: opts[:product_id]
      }
      |> Enum.reject(fn {_, v} -> is_nil(v) end)
      |> Enum.into(%{})

    Paddle.Request.get("/2.0/user/history", params)
  end
end
