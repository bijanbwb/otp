defmodule MultiDict do
  @spec new() :: map()
  def new(), do: %{}

  @spec add(map(), Map.key(), Map.value()) :: map()
  def add(dict, key, value) do
    dict |> Map.update(key, [value], &[value | &1])
  end

  @spec get(map(), Map.key()) :: [map()]
  def get(dict, key) do
    dict |> Map.get(key, [])
  end
end
