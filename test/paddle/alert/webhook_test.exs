defmodule Paddle.WebhookTest do
  use ExUnit.Case

  setup do
    bypass = Bypass.open(port: 12345)
    {:ok, bypass: bypass}
  end

  test "get webhooks history", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, ~s(
        {
          "success": true,
          "response": {
            "current_page": 1,
            "total_pages": 46,
            "alerts_per_page": 10,
            "total_alerts": 460,
            "query_head": "2015-07-17 14:04:06",
            "data": [
              {
                "id": 22257,
                "alert_name": "payment_refunded",
                "status": "success",
                "created_at": "2015-07-17 14:04:05",
                "updated_at": "2015-08-14 13:28:19",
                "attempts": 1,
                "fields": {
                  "order_id": 384920,
                  "amount": "100",
                  "currency": "USD",
                  "email": "xxxxx@xxxxx.com",
                  "marketing_consent": 1
                }
              }
            ],
            "query_tail": "2015-07-17 13:46:38"
          }
        }
      ))
    end)

    assert {:ok,
            %{
              current_page: 1,
              total_pages: 46,
              alerts_per_page: 10,
              total_alerts: 460,
              query_head: ~U"2015-07-17 14:04:06Z",
              data: [
                %Paddle.Webhook{
                  id: 22257,
                  alert_name: "payment_refunded",
                  status: "success",
                  created_at: ~U"2015-07-17 14:04:05Z",
                  updated_at: ~U"2015-08-14 13:28:19Z",
                  attempts: 1,
                  fields: %{
                    "order_id" => 384_920,
                    "amount" => "100",
                    "currency" => "USD",
                    "email" => "xxxxx@xxxxx.com",
                    "marketing_consent" => 1
                  }
                }
              ]
            }} ==
             Paddle.Webhook.get_history()
  end
end
