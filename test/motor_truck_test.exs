defmodule MotorTruckTest do
  use ExUnit.Case
  doctest MotorTruck

  test "greets the world" do
    assert MotorTruck.hello() == :world
  end
end
