defmodule TodoTest do
  use ExUnit.Case
  doctest Todo

  test "creates a new todo item" do
    todo =
      Todo.new(~D[2020-01-01], "Do Laundry")

    expected_output =
      %Todo{
        date: ~D[2020-01-01],
        title: "Do Laundry"
      }

    assert todo == expected_output
  end
end
