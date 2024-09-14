defmodule LorcanTest do
  use ExUnit.Case
  doctest Lorcan

  test "greets the world" do
    assert Lorcan.hello() == :world
  end
end
