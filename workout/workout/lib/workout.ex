defmodule Workout do
  @moduledoc """
  Create and track workouts.
  """

  alias MultiDict

  defstruct auto_id: 1, entries: %{}

  @spec new() :: %Workout{}
  def new(), do: %Workout{}

  @spec add_entry(%Workout{}, map()) :: %Workout{}
  def add_entry(workout, entry) do
    entry = Map.put(entry, :id, workout.auto_id)
    new_entries = Map.put(workout.entries, workout.auto_id, entry)

    %Workout{workout | entries: new_entries, auto_id: workout.auto_id + 1}
  end

  @spec entries(%Workout{}, Date.t()) :: [map()]
  def entries(workout, date) do
    workout.entries
    |> Stream.filter(fn {_, entry} -> entry.date == date end)
    |> Enum.map(fn {_, entry} -> entry end)
  end
end
