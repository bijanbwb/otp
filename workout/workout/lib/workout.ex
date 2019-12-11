defmodule Workout do
  @moduledoc """
  Create and track workouts.
  """

  @spec new() :: map()
  def new(), do: %{}

  @spec add_entry(map(), Date.t(), String.t()) :: map()
  def add_entry(workout, date, name) do
    workout |> Map.update(date, [name], &[name | &1])
  end

  @spec entries(map(), Date.t()) :: [String.t()]
  def entries(workout, date) do
    workout |> Map.get(date, [])
  end
end
