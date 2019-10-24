defmodule IslandsEngine.Guesses do
  alias IslandsEngine.{Coordinate, Guesses}

  @enforce_keys [:hits, :misses]
  defstruct [:hits, :misses]

  @doc """
  Create a new `Guesses` struct with empty hits and misses.

  ## Example Usage

      iex> IslandsEngine.Guesses.new()
      %IslandsEngine.Guesses{hits: MapSet.new([]), misses: MapSet.new([])}
  """
  def new() do
    %Guesses{
      hits: MapSet.new(),
      misses: MapSet.new()
    }
  end

  @doc """
  Guesses already have `hits` and `misses`, so we use `update_in/2` to
  place new results in those distinct `MapSet`s.

  ## Example Usage

      iex> guesses = IslandsEngine.Guesses.new()
      iex> {:ok, coordinate1} = IslandsEngine.Coordinate.new(8, 3)
      iex> IslandsEngine.Guesses.add(guesses, :hit, coordinate1)
      %IslandsEngine.Guesses{
        hits: MapSet.new([%IslandsEngine.Coordinate{col: 3, row: 8}]),
        misses: MapSet.new([])
      }
  """
  def add(%Guesses{} = guesses, :hit, %Coordinate{} = coordinate) do
    update_in(guesses.hits, &MapSet.put(&1, coordinate))
  end

  def add(%Guesses{} = guesses, :miss, %Coordinate{} = coordinate) do
    update_in(guesses.misses, &MapSet.put(&1, coordinate))
  end
end
