defmodule Paddle.Coupon do
  @type t :: %__MODULE__{
          coupon: String.t(),
          description: String.t(),
          discount_type: String.t(),
          discount_amount: number(),
          discount_currency: String.t() | nil,
          allowed_uses: pos_integer(),
          times_used: non_neg_integer(),
          is_recurring: boolean(),
          expires: Date.t() | nil
        }

  defstruct [
    :coupon,
    :description,
    :discount_type,
    :discount_amount,
    :discount_currency,
    :allowed_uses,
    :times_used,
    :is_recurring,
    :expires
  ]

  @doc """
  Create a new coupon for the given product or a checkout

  ## Examples
      params = %{
        coupon_prefix: "TEST",
        num_coupons: 5,
        description: "Test Coupon",
        coupon_type: "checkout",
        discount_type: "percentage",
        discount_amount: 10
      }
      Paddle.Coupon.create(params)  
      {:ok, %{
          coupon_codes: [
            "TEST-03C532BD",
            "TEST-491AC84D",
            "TEST-899202BB",
            "TEST-96518CAF",
            "TEST-2A2A7594"
          ]
      }}
  """
  @spec create(params, keyword()) :: {:ok, map} | {:error, Paddle.Error.t()}
        when params: %{
               optional(:coupon_code) => String.t(),
               optional(:coupon_prefix) => String.t(),
               optional(:num_coupons) => integer,
               optional(:description) => String.t(),
               :coupon_type => String.t(),
               optional(:product_ids) => [number],
               :discount_type => String.t(),
               :discount_amount => number,
               optional(:currency) => String.t(),
               optional(:allowed_uses) => integer,
               optional(:expires) => String.t(),
               optional(:recurring) => boolean,
               optional(:group) => String.t()
             }
  def create(params, opts \\ []) do
    params = Map.replace(params, :product_ids, Enum.join(params[:product_ids] || [], ","))

    case Paddle.Request.post("/2.1/product/create_coupon", params) do
      {:ok, list} -> {:ok, %{coupon_codes: list["coupon_codes"]}}
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  List all coupons valid for a specified one-time product or subscription plan

  ## Examples

      Paddle.Coupon.list(1234)  
      {:ok, [
        %Paddle.Coupon{
          coupon: "56604810a6990",
          description: "56604810a6dcd",
          discount_type: "percentage",
          discount_amount: 0.5,
          discount_currency: "USD",
          allowed_uses: 3,
          times_used: 2,
          is_recurring: true,
          expires: ~U"2020-12-03 00:00:00Z"
        }
      ]}
  """
  @spec list(integer, keyword()) :: {:ok, [t()]} | {:error, Paddle.Error.t()}
  def list(product_id, opts \\ []) do
    params = %{product_id: product_id}

    case Paddle.Request.post("/2.0/product/list_coupons", params) do
      {:ok, list} ->
        {:ok,
         Enum.map(list, fn elm ->
           Paddle.Helpers.map_to_struct(elm, __MODULE__)
           |> maybe_convert_date(:expires)
         end)}

      {:error, reason} ->
        reason
    end
  end

  @doc """
  Delete a given coupon and prevent it from being further used

  ## Examples
      Paddle.Coupon.delete("TEST") 
      {:ok, nil}
  """
  @spec delete(String.t(), params, keyword()) :: {:ok, [t()]} | {:error, Paddle.Error.t()}
        when params: %{
               optional(:product_id) => integer()
             }
  def delete(coupon_code, params \\ %{}, opts \\ []) do
    params = Map.merge(params, %{coupon_code: coupon_code})
    Paddle.Request.post("/2.0/product/delete_coupon", params)
  end

  @doc """
  Update an existing coupon in your account

  There are 2 main ways to select which coupon(s) you want to update:

  - Updating a single coupon code? Specify coupon_code.
  - Updating a group of coupons? Specify their unique group name.

  ## Examples

      params = %{
        coupon_code: "TEST",
        discount_amount: 20
      }
      Paddle.Coupon.update(params)
      {:ok, 1}
  """
  @spec update(params, keyword()) :: {:ok, map()} | {:error, Paddle.Error.t()}
        when params: %{
               optional(:coupon_code) => String.t(),
               optional(:group) => String.t(),
               optional(:new_coupon_code) => String.t(),
               optional(:new_group) => String.t(),
               optional(:product_ids) => String.t(),
               optional(:expires) => String.t(),
               optional(:allowed_uses) => integer,
               optional(:currency) => String.t(),
               optional(:discount_amount) => number,
               optional(:recurring) => boolean
             }
  def update(params, opts \\ []) do
    case Paddle.Request.post("/2.1/product/update_coupon", params) do
      {:ok, response} -> {:ok, response["updated"]}
      {:error, reason} -> reason
    end
  end

  defp maybe_convert_date(map, key) do
    datetime_string = Map.get(map, key)

    if datetime_string do
      {:ok, datetime, 0} = DateTime.from_iso8601(datetime_string <> "Z")
      Map.replace(map, key, datetime)
    else
      map
    end
  end
end
