defmodule Paddle.Error do
  @moduledoc """
  Error
  """
  @type t :: %__MODULE__{
          code: integer(),
          message: String.t()
        }
  defstruct [:code, :message]
end
