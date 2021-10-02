defmodule Paddle.OrderDetails do
  @moduledoc """
  OrderDetails
  """
  @doc """
  Get information about an order after a transaction completes

  ## Examples

      Paddle.OrderDetails.get(1234)
      %{
        "checkout" => %{
          "checkout_id" => "219233-chre53d41f940e0-58aqh94971",
          "image_url" => "https://paddle.s3.amazonaws.com/user/91/XWsPdfmISG6W5fgX5t5C_icon.png",
          "title" => "My Product"
        },
        "lockers" => [
          %{
            "download" => "https://mysite.com/download/my-app",
            "instructions" => "Simply enter your license code and click 'Activate",
            "license_code" => "ABC-123",
            "locker_id" => 1127139,
            "product_id" => 514032,
            "product_name" => "My Product Name"
          }
        ],
        "order" => %{
          "access_management" => %{
            "software_key" => []
          },
          "completed" => %{
            "date" => "2019-08-01 21:24:35.000000",
            "timezone" => "UTC",
            "timezone_type" => 3
          },
          "coupon_code" => nil,
          "currency" => "GBP",
          "customer" => %{
            "email" => "christian@paddle.com",
            "marketing_consent" => true
          },
          "customer_success_redirect_url" => "",
          "formatted_tax" => "£1.73",
          "formatted_total" => "£9.99",
          "has_locker" => true,
          "is_subscription" => false,
          "order_id" => 123456,
          "quantity" => 1,
          "receipt_url" => "https://my.paddle.com/invoice/826289/3219233-chre53d41f940e0-58aqh94971",
          "total" => "9.99",
          "total_tax" => "1.73"
        },
        "state" => "processed"
      }
  """
  @spec get(String.t(), String.t() | nil) :: {:ok, map} | {:error, Paddle.Error.t()}
  def get(checkout_id, callback_name \\ nil) do
    params =
      %{checkout_id: checkout_id, callback_name: callback_name}
      |> Enum.reject(fn {_, v} -> is_nil(v) end)
      |> Enum.into(%{})

    Paddle.Request.get("/1.0/order", params)
  end
end
