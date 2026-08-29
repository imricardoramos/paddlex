defmodule Paddle.Error do
  @moduledoc """
  Error struct returned by all API functions: `code` holds the Paddle API error code (or a transport-level atom such as `:econnrefused`) and `message` a human-readable description.
  """
  @type t :: %__MODULE__{
          code: integer(),
          message: String.t()
        }
  defstruct [:code, :message]
end
