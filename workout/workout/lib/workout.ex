defmodule Workout do
  @moduledoc """
  Create and track workouts.
  """

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

  @spec update_entry(%Workout{}, pos_integer(), (map() -> map())) :: %Workout{}
  def update_entry(workout, entry_id, updater_function) do
    workout.entries
    |> Map.fetch(entry_id)
    |> case do
      {:ok, old_entry} ->
        old_entry_id = old_entry.id
        new_entry = %{id: ^old_entry_id} = updater_function.(old_entry)
        new_entries = Map.put(workout.entries, new_entry.id, new_entry)

        %Workout{workout | entries: new_entries}

      :error ->
        workout
    end
  end

  @spec update_entry(%Workout{}, map()) :: %Workout{}
  def update_entry(workout, %{} = new_entry) do
    update_entry(workout, new_entry.id, fn _ -> new_entry end)
  end

  @spec delete_entry(%Workout{}, pos_integer()) :: %Workout{}
  def delete_entry(workout, entry_id) do
    new_entries = Map.delete(workout.entries, entry_id)

    %Workout{workout | entries: new_entries}
  end
end
