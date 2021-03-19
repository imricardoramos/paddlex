defmodule Paddle.Error do
  @type t :: %__MODULE__{
          code: integer(),
          message: String.t()
        }
  defstruct [:code, :message]
end
