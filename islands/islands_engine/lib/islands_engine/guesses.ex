defmodule IslandsEngine.Guesses do
  alias __MODULE__

  @enforce_keys [:hits, :misses]
  defstruct [:hits, :misses]

  @doc """


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
end
