defmodule Stack do
  @moduledoc """
  Documentation for Stack.
  """

  use GenServer

  # Client

  @doc """
  Start a `GenServer` with a default state.

  # Usage

      iex> Stack.start()
      {:ok, #PID<0.138.0>}
  """
  def start(default \\ []) when is_list(default) do
    GenServer.start_link(Stack, default, name: Stack)
  end

  @doc """
  Push new items onto the `Stack`.

  # Usage

      iex> Stack.push(1)
      :ok

      iex> Stack.push(2)
      :ok
  """
  def push(item) do
    GenServer.cast(Stack, {:push, item})
  end

  @doc """
  Pop the item off the top of the `Stack`.

  # Usage

      iex> Stack.pop()
      2
  """
  def pop() do
    GenServer.call(Stack, :pop)
  end

  @doc """
  Peek at the top item on the `Stack`.

  # Usage

      iex> Stack.peek()
      1
  """
  def peek() do
    GenServer.call(Stack, :peek)
  end

  # Server

  def init(stack) do
    {:ok, stack}
  end

  def handle_cast({:push, item}, state) do
    {:noreply, [item | state]}
  end

  def handle_call(:pop, _from, []) do
    {:reply, nil, []}
  end

  def handle_call(:pop, _from, [head | tail]) do
    {:reply, head, tail}
  end

  def handle_call(:peek, _from, []) do
    {:reply, nil, []}
  end

  def handle_call(:peek, _from, [head | _tail] = state) do
    {:reply, head, state}
  end
end
