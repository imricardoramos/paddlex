defmodule Paddle.Config do
  def resolve() do
    %{
      vendor_id: Application.get_env(:paddlex, :vendor_id),
      vendor_auth_code: Application.get_env(:paddlex, :vendor_auth_code),
      environment: Application.get_env(:paddlex, :environment)
    }
  end
end
