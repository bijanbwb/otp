defmodule Workout do
  @moduledoc """
  Create and track workouts.
  """

  alias MultiDict

  @spec new() :: map()
  def new(), do: MultiDict.new()

  @spec add_entry(map(), map()) :: map()
  def add_entry(workout, entry) do
    workout |> MultiDict.add(entry.date, entry)
  end

  @spec entries(map(), Date.t()) :: [map()]
  def entries(workout, date) do
    workout |> MultiDict.get(date)
  end
end
