defmodule Paddle.OrderDetailsTest do
  use ExUnit.Case

  setup do
    bypass = Bypass.open(port: 12_345)
    {:ok, bypass: bypass}
  end

  test "get order details", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, ~s(
        {
          "checkout": {
            "checkout_id": "219233-chre53d41f940e0-58aqh94971",
            "image_url": "https://paddle.s3.amazonaws.com/user/91/XWsPdfmISG6W5fgX5t5C_icon.png",
            "title": "My Product"
          },
          "lockers": [
            {
              "download": "https://mysite.com/download/my-app",
              "instructions": "Simply enter your license code and click 'Activate",
              "license_code": "ABC-123",
              "locker_id": 1127139,
              "product_id": 514032,
              "product_name": "My Product Name"
            }
          ],
          "order": {
            "access_management": {
              "software_key": []
            },
            "completed": {
              "date": "2019-08-01 21:24:35.000000",
              "timezone": "UTC",
              "timezone_type": 3
            },
            "coupon_code": null,
            "currency": "GBP",
            "customer": {
              "email": "christian@paddle.com",
              "marketing_consent": true
            },
            "customer_success_redirect_url": "",
            "formatted_tax": "£1.73",
            "formatted_total": "£9.99",
            "has_locker": true,
            "is_subscription": false,
            "order_id": 123456,
            "quantity": 1,
            "receipt_url": "https://my.paddle.com/invoice/826289/3219233-chre53d41f940e0-58aqh94971",
            "total": "9.99",
            "total_tax": "1.73"
          },
          "state": "processed"
        }
      ))
    end)

    assert %{
             "checkout" => %{
               "checkout_id" => "219233-chre53d41f940e0-58aqh94971",
               "image_url" =>
                 "https://paddle.s3.amazonaws.com/user/91/XWsPdfmISG6W5fgX5t5C_icon.png",
               "title" => "My Product"
             },
             "lockers" => [
               %{
                 "download" => "https://mysite.com/download/my-app",
                 "instructions" => "Simply enter your license code and click 'Activate",
                 "license_code" => "ABC-123",
                 "locker_id" => 1_127_139,
                 "product_id" => 514_032,
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
               "order_id" => 123_456,
               "quantity" => 1,
               "receipt_url" =>
                 "https://my.paddle.com/invoice/826289/3219233-chre53d41f940e0-58aqh94971",
               "total" => "9.99",
               "total_tax" => "1.73"
             },
             "state" => "processed"
           } == Paddle.OrderDetails.get("219233-chre53d41f940e0-58aqh94971")
  end
end
