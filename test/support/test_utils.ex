defmodule Paddle.Support.TestUtils do
  @moduledoc """
  Some utility functions for better testability.
  """

  def read_request_body(conn) do
    {:ok, recv_body, _} = Plug.Conn.read_body(conn)
    recv_body
  end

  def read_decoded_request_body(conn) do
    read_request_body(conn) |> URI.decode_query()
  end
end
