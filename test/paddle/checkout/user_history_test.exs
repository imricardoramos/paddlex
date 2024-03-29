defmodule Paddle.UserHistoryTest do
  use ExUnit.Case

  setup do
    bypass = Bypass.open(port: 12_345)
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

    assert {:ok,
            "We've sent details of your past transactions, licenses and downloads to you via email."} ==
             Paddle.UserHistory.get("user@example.com", vendor_id: 1234)
  end

  test "get user history without any options", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, ~s(
        {
          "success": true,
          "message": "We've sent details of your past transactions, licenses and downloads to you via email."
        }
      ))
    end)

    assert {:ok,
            "We've sent details of your past transactions, licenses and downloads to you via email."} ==
             Paddle.UserHistory.get("user@example.com")
  end
end
