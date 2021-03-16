defmodule PaddleTest do
  use ExUnit.Case
  doctest Paddle

  test "greets the world" do
    assert Paddle.hello() == :world
  end
end
