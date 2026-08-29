defmodule Paddle.RequestTest do
  use Paddle.Case

  alias Paddle.Request

  test "post returns error when credentials are not configured", %{bypass: bypass} do
    Application.delete_env(:paddlex, :vendor_id)

    on_exit(fn ->
      Application.put_env(:paddlex, :vendor_id, 12_345)
    end)

    assert {:error, %Paddle.Error{code: :missing_configuration}} = Request.post("/some_path")

    # per-call override supplies the missing credential
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, ~s({"success": true}))
    end)

    assert {:ok, nil} = Request.post("/some_path", %{}, vendor_id: 12_345)
  end

  test "per-call base_url override takes precedence", %{bypass: bypass} do
    Application.delete_env(:paddlex, :vendors_base_url)

    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, ~s({"success": true}))
    end)

    assert {:ok, nil} =
             Request.post("/some_path", %{}, vendors_base_url: "http://localhost:#{bypass.port}")
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

  test "get returns error message on transport error", %{bypass: bypass} do
    Bypass.down(bypass)

    assert {:error, %Paddle.Error{code: :econnrefused, message: "connection refused"}} =
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
