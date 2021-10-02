defmodule Paddle.PayLinkTest do
  use ExUnit.Case

  setup do
    bypass = Bypass.open(port: 12_345)
    {:ok, bypass: bypass}
  end

  # I COULD NOT TEST THIS
  # test "generate pay link", %{bypass: bypass} do
  #   Bypass.expect(bypass, fn conn ->
  #     Plug.Conn.resp(conn, 200, ~s(
  #       {
  #         "success": true,
  #         "response": {
  #           "url": "https://checkout.paddle.com/checkout/custom/eyJ0IjoiUHJvZ……."
  #         }
  #       }
  #     ))
  #   end)
  #   params = %{
  #     product_id: 1234,
  #     allowed_uses: 10
  #     expires_at: ~D[2018-10-10]
  #   }
  #   assert {:ok, "https://checkout.paddle.com/checkout/custom/eyJ0IjoiUHJvZ……"}
  #     == Paddle.PayLink.generate(%{})
  # end
end
