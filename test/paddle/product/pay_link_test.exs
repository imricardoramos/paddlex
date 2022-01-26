defmodule Paddle.PayLinkTest do
  use ExUnit.Case

  import Paddle.Support.TestUtils

  setup do
    bypass = Bypass.open(port: 12_345)
    {:ok, bypass: bypass}
  end

  @generated_reponse_url "https://checkout.paddle.com/checkout/custom/verylongstring"

  test "generate pay link with 'array lists' successfully", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      request_body = read_decoded_request_body(conn)

      assert %{
               "product_id" => "1234",
               "title" => "Nice title",
               "webhook_url" => "webhook_url",
               "prices[0]" => "EUR:1.00",
               "prices[1]" => "USD:1.23",
               "recurring_prices[0]" => "EUR:4.56",
               "recurring_prices[1]" => "USD:4.56",
               "trial_days" => "14",
               "custom_message" => "custom_message",
               "coupon_code" => "coupon_code",
               "discountable" => "false",
               "image_url" => "image_url",
               "return_url" => "return_url",
               "quantity_variable" => "false",
               "quantity" => "200",
               "expires" => "2018-10-10",
               "affiliates[0]" => "12345:0.25",
               "affiliates[1]" => "67891:0.5",
               "recurring_affiliate_limit" => "12",
               "marketing_consent" => "true",
               "customer_email" => "customer_email",
               "customer_country" => "customer_country",
               "customer_postcode" => "customer_postcode",
               "passthrough" => "passthrough",
               "vat_number" => "vat_number",
               "vat_company_name" => "vat_company_name",
               "vat_street" => "vat_street",
               "vat_city" => "vat_city",
               "vat_state" => "vat_state",
               "vat_country" => "vat_country",
               "vat_postcode" => "vat_postcode"
             } = request_body

      Plug.Conn.resp(conn, 200, ~s(
        {
          "success": true,
          "response": {
            "url": "#{@generated_reponse_url}"
          }
        }
      ))
    end)

    params = %{
      product_id: 1234,
      title: "Nice title",
      webhook_url: "webhook_url",
      prices: ["EUR:1.00", "USD:1.23"],
      recurring_prices: ["EUR:4.56", "USD:4.56"],
      trial_days: 14,
      custom_message: "custom_message",
      coupon_code: "coupon_code",
      discountable: false,
      image_url: "image_url",
      return_url: "return_url",
      quantity_variable: false,
      quantity: 200,
      expires: ~D[2018-10-10],
      affiliates: ["12345:0.25", "67891:0.5"],
      recurring_affiliate_limit: 12,
      marketing_consent: true,
      customer_email: "customer_email",
      customer_country: "customer_country",
      customer_postcode: "customer_postcode",
      passthrough: "passthrough",
      vat_number: "vat_number",
      vat_company_name: "vat_company_name",
      vat_street: "vat_street",
      vat_city: "vat_city",
      vat_state: "vat_state",
      vat_country: "vat_country",
      vat_postcode: "vat_postcode"
    }

    assert {:ok, @generated_reponse_url} ==
             Paddle.PayLink.generate(params)
  end

  test "generate pay link without 'array lists' successfully", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      request_body = read_decoded_request_body(conn)

      assert %{
               "product_id" => "1234",
               "title" => "Nice title"
             } = request_body

      Plug.Conn.resp(conn, 200, ~s(
        {
          "success": true,
          "response": {
            "url": "#{@generated_reponse_url}"
          }
        }
      ))
    end)

    params = %{
      product_id: 1234,
      title: "Nice title"
    }

    assert {:ok, @generated_reponse_url} ==
             Paddle.PayLink.generate(params)
  end

  test "returns error when generations fails", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, ~s(
        {
          "success": false,
          "error": {
              "code": 139,
              "message": "Error message"
          }
      }
      ))
    end)

    params = %{
      product_id: 1234,
      title: "Nice title"
    }

    assert {:error, %Paddle.Error{code: 139, message: "Error message"}} ==
             Paddle.PayLink.generate(params)
  end
end
