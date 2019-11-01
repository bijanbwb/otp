defmodule IslandsEngine.Game do
  use GenServer

  @doc """

  ## Example Usage

      iex> {:ok, game} = GenServer.start_link(Game, %{}, [])
      {:ok, #PID<0.152.0>}

      iex> GenServer.cast(game, {:message, "Hello"})
      :ok

      iex> GenServer.call(game, :message)
      %{goodbye: "World", hello: "Hello"}
  """
  def init(options \\ %{}) do
    {:ok, options}
  end

  def handle_cast({:message, value}, state) do
    {:noreply, Map.put(state, :hello, value)}
  end

  def handle_call(:message, _from, state) do
    {:reply, Map.put(state, :goodbye, "World"), state}
  end
end
