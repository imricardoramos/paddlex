defmodule Paddle.RequestTest do
  use ExUnit.Case

  alias Paddle.Request

  setup do
    bypass = Bypass.open(port: 12_345)
    {:ok, bypass: bypass}
  end

  test "get returns ok", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, ~s({
        "success": true,
        "some_key": "some_value"
      }))
    end)

    assert {:ok, _} = Request.get("/some_path")
  end

  test "get returns error message on api error", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, ~s({
        "success": false,
        "error": {
          "code": "some_error_code",
          "message": "some error message"
        }
      }))
    end)

    assert {:error, %Paddle.Error{code: "some_error_code", message: "some error message"}} =
             Request.get("/some_path")
  end

  test "post returns ok", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, ~s({
        "success": true,
        "some_key": "some_value"
      }))
    end)

    assert {:ok, _} = Request.post("/some_path")
  end

  test "post returns error message", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, ~s({
        "success": false,
        "error": {
          "code": "some_error_code",
          "message": "some error message"
        }
      }))
    end)

    assert {:error, %Paddle.Error{code: "some_error_code", message: "some error message"}} =
             Request.get("/some_path")
  end
end
