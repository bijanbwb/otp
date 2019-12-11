defmodule Todo do
  @moduledoc """
  Create new todo items.
  """

  alias __MODULE__

  # Struct

  @enforce_keys [:date, :title]
  defstruct [:date, :title]

  # Types

  @type todo() :: %Todo{
          date: Date.t(),
          title: String.t()
        }

  # Constructor

  @doc """
  Create a new `Todo`.

  ## Usage

      iex> Todo.new(~D[2020-01-01], "Do Laundry")
      %Todo{
        date: ~D[2020-01-01],
        title: "Do Laundry"
      }
  """
  @spec new(
          date :: Date.t(),
          title :: String.t()
        ) :: todo()
  def new(date, title) do
    %Todo{
      date: date,
      title: title,
    }
  end
end
