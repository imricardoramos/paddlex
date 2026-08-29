defmodule Paddle.Case do
  @moduledoc """
  Test case template that starts a `Bypass` server on a random port and points
  the library's base URLs at it.
  """
  use ExUnit.CaseTemplate

  setup do
    bypass = Bypass.open()
    base_url = "http://localhost:#{bypass.port}/api"
    Application.put_env(:paddlex, :vendors_base_url, base_url)
    Application.put_env(:paddlex, :checkout_base_url, base_url)

    on_exit(fn ->
      Application.delete_env(:paddlex, :vendors_base_url)
      Application.delete_env(:paddlex, :checkout_base_url)
    end)

    {:ok, bypass: bypass}
  end
end
