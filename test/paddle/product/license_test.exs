defmodule Paddle.LicenseTest do
  use ExUnit.Case

  setup do
    bypass = Bypass.open(port: 12_345)
    {:ok, bypass: bypass}
  end

  test "generate license", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, ~s(
        {
          "success": true,
          "response": {
            "license_code": "2DEDF6A4-86420251-0927C417-43523113-CA22C29B",
            "expires_at": "2018-10-10"
          }
        }
      ))
    end)

    params = %{
      product_id: 1234,
      allowed_uses: 10,
      expires_at: ~D[2018-10-10]
    }

    assert {:ok,
            %Paddle.License{
              license_code: "2DEDF6A4-86420251-0927C417-43523113-CA22C29B",
              expires_at: ~D"2018-10-10"
            }} == Paddle.License.generate(params)
  end
end
