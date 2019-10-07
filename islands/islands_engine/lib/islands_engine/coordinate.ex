defmodule IslandsEngine.Coordinate do
  alias __MODULE__

  @enforce_keys [:row, :col]
  defstruct [:row, :col]

  @board_range 1..10

  @doc """
  Create a new Coordinate struct with a `row` and `col`.

  ## Example Usage

      iex> IslandsEngine.Coordinate.new(1, 1)
      {:ok, %IslandsEngine.Coordinate{col: 1, row: 1}}
  """
  def new(row, col) when row in @board_range and col in @board_range do
    {:ok, %Coordinate{row: row, col: col}}
  end

  def new(_row, _col) do
    {:error, :invalid_coordinate}
  end
end
