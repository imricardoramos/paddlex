defmodule Paddle.Product do
  @type t :: %__MODULE__{
          id: integer,
          name: String.t(),
          description: String.t() | nil,
          base_price: number,
          sale_price: nil,
          screenshots: list,
          icon: String.t(),
          currency: String.t()
        }

  defstruct [:id, :name, :description, :base_price, :sale_price, :screenshots, :icon, :currency]

  @doc """
  List all published one-time products in your account

  ## Examples

      Paddle.Product.list() 
      {:ok, [
        %Paddle.Product{
          id: 489171,
          name: "A Product",
          description: "A description of the product.",
          base_price: 58,
          sale_price: nil,
          currency: "USD",
          screenshots: [],
          icon: "https://paddle-static.s3.amazonaws.com/email/2013-04-10/og.png"
        },
        %Paddle.Product{
          id: 489278,
          name: "Another Product",
          description: nil,
          base_price: 39.99,
          sale_price: nil,
          currency: "GBP",
          screenshots: [],
          icon: "https://paddle.s3.amazonaws.com/user/91/489278geekbench.png"
        },
      ]}
  """
  @spec list(keyword()) :: {:ok, [t()]} | {:error, Paddle.Error.t()}
  def list(opts \\ []) do
    case Paddle.Request.post("/2.0/product/get_products") do
      {:ok, response} ->
        {:ok,
         Enum.map(response["products"], fn elm ->
           Paddle.Helpers.map_to_struct(elm, __MODULE__)
         end)}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
