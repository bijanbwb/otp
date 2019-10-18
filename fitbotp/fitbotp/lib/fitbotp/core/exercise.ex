defmodule Fitbotp.Core.Exercise do
  @moduledoc """
  Create new exercise records.
  """

  alias __MODULE__

  # Struct

  @enforce_keys [:datetime, :icon, :name, :reps, :sets, :weight]
  defstruct [:datetime, :icon, :name, :reps, :sets, :weight]

  # Types

  @type exercise() :: %Exercise{
          datetime: DateTime.t(),
          icon: String.t(),
          name: String.t(),
          reps: pos_integer(),
          sets: pos_integer(),
          weight: float()
        }

  # Constructor

  @doc """
  Create a new `Exercise`.

  ## Usage

      iex> Exercise.new("🏋", "Barbell Squat", 5, 1, 45)
      %Fitbotp.Core.Exercise{
        datetime: ~U[2019-10-18 19:25:22.077504Z],
        icon: "🏋",
        name: "Barbell Squat",
        reps: 5,
        sets: 1,
        weight: 45
      }
  """
  @spec new(
          icon :: String.t(),
          name :: String.t(),
          reps :: pos_integer(),
          sets :: pos_integer(),
          weight :: float()
        ) :: exercise()
  def new(icon, name, reps, sets, weight) do
    %Exercise{
      datetime: DateTime.utc_now(),
      icon: icon,
      name: name,
      reps: reps,
      sets: sets,
      weight: weight
    }
  end
end
