defmodule IslandsEngine.Island do
  @moduledoc """
  Islands have predefined shapes that consist of a list of coordinates.

  The `new/2` constructor function allows us to take a shape (from the
  `offsets/1` function) and use it to populate the coordinates for the island
  using the private `add_coordinates/2` function.
  """
  alias IslandsEngine.{Coordinate, Island}

  @enforce_keys [:coordinates, :hit_coordinates]
  defstruct [:coordinates, :hit_coordinates]

  def new(type, %Coordinate{} = upper_left) do
    with [_ | _] = offsets <- offsets(type),
         %MapSet{} = coordinates <- add_coordinates(offsets, upper_left) do
      {:ok,
       %Island{
         coordinates: coordinates,
         hit_coordinates: MapSet.new()
       }}
    else
      error -> error
    end
  end

  def new() do
    %Island{
      coordinates: MapSet.new(),
      hit_coordinates: MapSet.new()
    }
  end

  # Island Shapes

  def types(),
    do: [
      :atoll,
      :dot,
      :l_shape,
      :s_shape,
      :square
    ]

  def offsets(:atoll), do: [{0, 0}, {0, 1}, {1, 1}, {2, 0}, {2, 1}]
  def offsets(:dot), do: [{0, 0}]
  def offsets(:l_shape), do: [{0, 0}, {1, 0}, {2, 0}, {2, 1}]
  def offsets(:s_shape), do: [{0, 1}, {0, 2}, {1, 0}, {1, 1}]
  def offsets(:square), do: [{0, 0}, {0, 1}, {1, 0}, {1, 1}]
  def offsets(_shape), do: {:error, :invalid_island_type}

  # Add Coordinates

  defp add_coordinates(offsets, upper_left) do
    Enum.reduce_while(offsets, MapSet.new(), fn offset, acc ->
      add_coordinate(acc, upper_left, offset)
    end)
  end

  defp add_coordinate(coordinates, %Coordinate{row: row, col: col}, {row_offset, col_offset}) do
    case Coordinate.new(row + row_offset, col + col_offset) do
      {:ok, coordinate} ->
        {:cont, MapSet.put(coordinates, coordinate)}

      {:error, :invalid_coordinate} ->
        {:halt, {:error, :invalid_coordinate}}
    end
  end

  # Overlaps?

  def overlaps?(existing_island, new_island) do
    not MapSet.disjoint?(existing_island.coordinates, new_island.coordinates)
  end

  # Guess

  def guess(island, coordinate) do
    case MapSet.member?(island.coordinates, coordinate) do
      true ->
        hit_coordinates = MapSet.put(island.hit_coordinates, coordinate)
        {:hit, %{island | hit_coordinates: hit_coordinates}}

      false ->
        :miss
    end
  end

  # Forested?

  def forested?(island) do
    MapSet.equal?(island.coordinates, island.hit_coordinates)
  end
end
