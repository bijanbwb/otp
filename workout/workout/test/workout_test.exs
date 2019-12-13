defmodule WorkoutTest do
  use ExUnit.Case
  doctest Workout

  test "creates a new workout" do
    expected = %Workout{auto_id: 1, entries: %{}}

    assert Workout.new() == expected
  end

  test "adds an entry to a workout" do
    entry = %{date: ~D[2020-01-01], name: "Push-ups"}

    workout =
      Workout.new()
      |> Workout.add_entry(entry)

    expected = %Workout{auto_id: 2, entries: %{1 => Map.put(entry, :id, 1)}}

    assert workout == expected
  end

  test "adds multiple entries with the same date to a workout" do
    entry1 = %{date: ~D[2020-01-01], name: "Push-ups"}
    entry2 = %{date: ~D[2020-01-01], name: "Chin-ups"}

    workout =
      Workout.new()
      |> Workout.add_entry(entry1)
      |> Workout.add_entry(entry2)

    expected = %Workout{
      auto_id: 3,
      entries: %{
        1 => Map.put(entry1, :id, 1),
        2 => Map.put(entry2, :id, 2)
      }
    }

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

    expected = [Map.put(entry1, :id, 1)]

    assert entries == expected
  end

  test "updates an entry in a workout" do
    entry1 = %{date: ~D[2020-01-01], name: "Push-ups"}

    updater_function = fn entry ->
      Map.update(entry, :name, entry.name, fn _ -> "Deadlifts" end)
    end

    workout =
      Workout.new()
      |> Workout.add_entry(entry1)
      |> Workout.update_entry(1, updater_function)

    entries = Workout.entries(workout, entry1.date)

    expected = [%{id: 1, date: ~D[2020-01-01], name: "Deadlifts"}]

    assert entries == expected
  end

  test "deletes an entry from a workout" do
    entry1 = %{date: ~D[2020-01-01], name: "Push-ups"}
    entry2 = %{date: ~D[2020-01-01], name: "Chin-ups"}

    workout =
      Workout.new()
      |> Workout.add_entry(entry1)
      |> Workout.add_entry(entry2)
      |> Workout.delete_entry(1)

    entries = Workout.entries(workout, entry1.date)

    expected = [Map.put(entry2, :id, 2)]

    assert entries == expected
  end
end
