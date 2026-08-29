defmodule Paddle.PayLink do
  @moduledoc """
  Generate custom pay links to charge users for products or subscription plans.
  """
  @doc """
  Generate a link with custom attributes set for a one-time or subscription checkout
  """
  @spec generate(params, keyword()) :: {:ok, String.t()} | {:error, Paddle.Error.t()}
        when params: %{
               optional(:product_id) => integer,
               optional(:title) => String.t(),
               optional(:webhook_url) => String.t(),
               optional(:prices) => [String.t()],
               optional(:recurring_prices) => [String.t()],
               optional(:trial_days) => integer,
               optional(:custom_message) => String.t(),
               optional(:coupon_code) => String.t(),
               optional(:discountable) => boolean,
               optional(:image_url) => String.t(),
               optional(:return_url) => String.t(),
               optional(:quantity_variable) => boolean,
               optional(:quantity) => integer(),
               optional(:expires) => String.t(),
               optional(:affiliates) => [String.t()],
               optional(:recurring_affiliate_limit) => integer(),
               optional(:marketing_consent) => boolean,
               optional(:customer_email) => String.t(),
               optional(:customer_country) => String.t(),
               optional(:customer_postcode) => String.t(),
               optional(:passthrough) => String.t(),
               optional(:vat_number) => String.t(),
               optional(:vat_company_name) => String.t(),
               optional(:vat_street) => String.t(),
               optional(:vat_city) => String.t(),
               optional(:vat_state) => String.t(),
               optional(:vat_country) => String.t(),
               optional(:vat_postcode) => String.t()
             }
  def generate(params, opts \\ []) do
    params =
      params
      |> maybe_set_list_as_array(:prices)
      |> maybe_set_list_as_array(:recurring_prices)
      |> maybe_set_list_as_array(:affiliates)

    case Paddle.Request.post("/2.0/product/generate_pay_link", params, opts) do
      {:ok, response} -> {:ok, response["url"]}
      {:error, reason} -> {:error, reason}
    end
  end

  defp maybe_set_list_as_array(params, element) do
    price_array_map =
      Map.get(params, element, [])
      |> Enum.with_index()
      |> Enum.map(&{"#{element}[#{elem(&1, 1)}]", elem(&1, 0)})
      |> Map.new()

    Map.merge(params, price_array_map) |> Map.drop([element])
  end
end
