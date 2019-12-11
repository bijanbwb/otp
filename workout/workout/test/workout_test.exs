defmodule WorkoutTest do
  use ExUnit.Case
  doctest Workout

  test "creates a new workout" do
    assert Workout.new() == %{}
  end

  test "adds an entry to a workout" do
    workout =
      Workout.new()
      |> Workout.add_entry(~D[2020-01-01], "Push-ups")

    expected = %{~D[2020-01-01] => ["Push-ups"]}

    assert workout == expected
  end

  test "adds multiple entries to a workout" do
    workout =
      Workout.new()
      |> Workout.add_entry(~D[2020-01-01], "Push-ups")
      |> Workout.add_entry(~D[2020-01-01], "Chin-ups")

    expected = %{~D[2020-01-01] => ["Chin-ups", "Push-ups"]}

    assert workout == expected
  end

  test "finds entries for a given date" do
    workout =
      Workout.new()
      |> Workout.add_entry(~D[2020-01-01], "Push-ups")
      |> Workout.add_entry(~D[2020-01-02], "Chin-ups")

    entries = Workout.entries(workout, ~D[2020-01-01])

    expected = ["Push-ups"]

    assert entries == expected
  end
end
