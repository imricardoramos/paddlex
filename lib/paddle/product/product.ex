defmodule Paddle.Product.Product do
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

  @spec list(keyword()) :: {:ok, [t()]} | {:error, Paddle.Error.t()}
  def list(opts \\ []) do
    case Paddle.Request.post("/2.0/product/get_products") do
      {:ok, response} -> {:ok,
          Enum.map(response["products"], fn elm ->
            Paddle.Helpers.map_to_struct(elm, __MODULE__)
          end)
      }
      {:error, reason} -> {:error, reason}
    end
  end
end
