defmodule Paddle.Product.License do
  @type t :: %__MODULE__{
    license_code: String.t(),
    expires_at: Date.t()
  }
  defstruct [:license_code, :expires_at]

  @spec generate(params) :: {:ok, t} | {:error, Paddle.Error.t()}
    when params: %{
      :product_id => number,
      :allowed_uses => integer,
      optional(:expires_at) => Date.t(),
    }
  def generate(params) do
    case Paddle.Request.post("/2.0/product/generate_license", params) do
      {:ok, license} -> {:ok,
            Paddle.Helpers.map_to_struct(license, __MODULE__)
            |> maybe_convert_date(:expires_at)
      }
      {:error, reason} -> reason
    end
  end

  defp maybe_convert_date(map, key) do
    date_string = Map.get(map,key)
    if date_string do
      date = Date.from_iso8601!(date_string)
      Map.replace(map, key, date)
    else
      map
    end
  end
end
