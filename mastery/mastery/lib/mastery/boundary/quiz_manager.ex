defmodule Mastery.Boundary.QuizManager do
  @moduledoc """
  GenServer initializes with an empty map of `quizzes`.

  `handle_call/3` with a `:build_quiz` message will create a new quiz, add it
  to the `quizzes` map, and return the new state.

  ## Example Usage

  iex> GenServer.start_link(QuizManager, %{}, name: QuizManager)
  {:ok, #PID<0.123.0>}
  iex> QuizManager.build_quiz(title: :quiz)
  :ok
  iex> QuizManager.add_template(:quiz, Math.template_fields)
  :ok
  iex> QuizManager.lookup_quiz_by_title(:quiz)
  %Mastery.Core.Quiz{...}
  """
  alias Mastery.Core.Quiz

  use GenServer

  # Supervision

  def start_link(options \\ []) do
    GenServer.start_link(__MODULE__, %{}, options)
  end

  # API

  def build_quiz(manager \\ __MODULE__, quiz_fields) do
    GenServer.call(manager, {:build_quiz, quiz_fields})
  end

  def add_template(manager \\ __MODULE__, quiz_title, template_fields) do
    GenServer.call(manager, {:add_template, quiz_title, template_fields})
  end

  def lookup_quiz_by_title(manager \\ __MODULE__, quiz_title) do
    GenServer.call(manager, {:lookup_quiz_by_title, quiz_title})
  end

  # init

  def init(quizzes) when is_map(quizzes), do: {:ok, quizzes}
  def init(_quizzes), do: {:error, "quizzes must be a map"}

  # handle_call

  def handle_call({:build_quiz, quiz_fields}, _from, quizzes) do
    quiz = Quiz.new(quiz_fields)
    new_quizzes = Map.put(quizzes, quiz.title, quiz)

    {:reply, :ok, new_quizzes}
  end

  def handle_call({:add_template, quiz_title, template_fields}, _from, quizzes) do
    new_quizzes =
      Map.update!(quizzes, quiz_title, fn quiz ->
        Quiz.add_template(quiz, template_fields)
      end)

    {:reply, :ok, new_quizzes}
  end

  def handle_call({:lookup_quiz_by_title, quiz_title}, _from, quizzes) do
    {:reply, quizzes[quiz_title], quizzes}
  end
end
