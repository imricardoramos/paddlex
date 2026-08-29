defmodule Paddle.ProductPaymentTest do
  use Paddle.Case

  test "refund payment", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, ~s(
        {
          "success": true,
          "response": {
            "refund_request_id": 12345
          }
        }
      ))
    end)

    assert {:ok, 12_345} ==
             Paddle.ProductPayment.refund(10)
  end
end
