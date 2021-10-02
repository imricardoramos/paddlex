defmodule Paddle.License do
  @moduledoc """
  License
  """
  @type t :: %__MODULE__{
          license_code: String.t(),
          expires_at: Date.t()
        }
  defstruct [:license_code, :expires_at]

  @doc """
  Generate a Paddle-framework license

  ## Examples

      params = %{
        product_id: 1234,
        allowed_uses: 10,
        expires_at: ~D[2018-10-10]
      }
      Paddle.License.generate(params) 
      {:ok, %Paddle.License{
          license_code: "2DEDF6A4-86420251-0927C417-43523113-CA22C29B",
          expires_at: ~D[2018-10-10]
      }}
  """
  @spec generate(params) :: {:ok, t} | {:error, Paddle.Error.t()}
        when params: %{
               :product_id => number,
               :allowed_uses => integer,
               optional(:expires_at) => Date.t()
             }
  def generate(params) do
    case Paddle.Request.post("/2.0/product/generate_license", params) do
      {:ok, license} ->
        {:ok,
         Paddle.Helpers.map_to_struct(license, __MODULE__)
         |> maybe_convert_date(:expires_at)}

      {:error, reason} ->
        reason
    end
  end

  defp maybe_convert_date(map, key) do
    date_string = Map.get(map, key)

    if date_string do
      date = Date.from_iso8601!(date_string)
      Map.replace(map, key, date)
    else
      map
    end
  end
end
