defmodule WorkoutTest do
  use ExUnit.Case
  doctest Workout

  test "creates a new workout" do
    expected = %{}

    assert Workout.new() == expected
  end

  test "adds an entry to a workout" do
    entry = %{date: ~D[2020-01-01], name: "Push-ups"}

    workout =
      Workout.new()
      |> Workout.add_entry(entry)

    expected = %{entry.date => [entry]}

    assert workout == expected
  end

  test "adds multiple entries with the same date to a workout" do
    entry1 = %{date: ~D[2020-01-01], name: "Push-ups"}
    entry2 = %{date: ~D[2020-01-01], name: "Chin-ups"}

    workout =
      Workout.new()
      |> Workout.add_entry(entry1)
      |> Workout.add_entry(entry2)

    expected = %{entry1.date => [entry2, entry1]}

    assert workout == expected
  end

  test "finds entries for a given date" do
    entry1 = %{date: ~D[2020-01-01], name: "Push-ups"}
    entry2 = %{date: ~D[2020-02-02], name: "Chin-ups"}

    workout =
      Workout.new()
      |> Workout.add_entry(entry1)
      |> Workout.add_entry(entry2)

    entries = Workout.entries(workout, entry1.date)

    expected = [entry1]

    assert entries == expected
  end
end
