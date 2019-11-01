defmodule IslandsEngine.Game do
  @moduledoc """

  ## Example Usage

      iex> {:ok, game} = Game.start_link("Bijan")
      {:ok, #PID<0.152.0>}

      iex> Game.add_player(game, "Riley")
      :ok

      iex> state_data = :sys.get_state(game)
      # ...

      iex> state_data.player2.name
      "Riley"
  """
  use GenServer

  alias IslandsEngine.{Board, Guesses, Rules}

  # API

  def start_link(name) when is_binary(name) do
    GenServer.start_link(__MODULE__, name, [])
  end

  def add_player(game, name) when is_binary(name) do
    GenServer.call(game, {:add_player, name})
  end

  defp update_player2_name(state_data, name) do
    put_in(state_data.player2.name, name)
  end

  defp update_rules(state_data, rules) do
    %{state_data | rules: rules}
  end

  defp reply_success(state_data, reply) do
    {:reply, reply, state_data}
  end

  # Callbacks

  def init(name) do
    player1 = %{name: name, board: Board.new(), guesses: Guesses.new()}
    player2 = %{name: nil, board: Board.new(), guesses: Guesses.new()}
    state = %{player1: player1, player2: player2, rules: %Rules{}}

    {:ok, state}
  end

  def handle_call({:add_player, name}, _from, state_data) do
    with {:ok, rules} <- Rules.check(state_data.rules, :add_player) do
      state_data
      |> update_player2_name(name)
      |> update_rules(rules)
      |> reply_success(:ok)
    else
      :error -> {:reply, :error, state_data}
    end
  end
end
