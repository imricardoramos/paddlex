defmodule Paddle.Checkout.UserHistoryTest do
  use ExUnit.Case

  setup do
    bypass = Bypass.open(port: 12345)
    {:ok, bypass: bypass}
  end

  test "get user history", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, ~s(
        {
          "success": true,
          "message": "We've sent details of your past transactions, licenses and downloads to you via email."
        }
      ))
    end)
    assert {:ok, "We've sent details of your past transactions, licenses and downloads to you via email."}
    == Paddle.Checkout.UserHistory.get("user@example.com", vendor_id: 1234)
  end
end
