defmodule Mastery.Boundary.QuizManager do
  @moduledoc """
  GenServer initializes with an empty map of `quizzes`.

  `handle_call/3` will create a new quiz, add it to the `quizzes` map, and
  return the new state.
  """
  alias Mastery.Core.Quiz

  use GenServer

  def init(quizzes) when is_map(quizzes), do: {:ok, quizzes}
  def init(_quizzes), do: {:error, "quizzes must be a map"}

  def handle_call({:build_quiz, quiz_fields}, _from, quizzes) do
    quiz = Quiz.new(quiz_fields)
    new_quizzes = Map.put(quizzes, quiz.title, quiz)

    {:reply, :ok, new_quizzes}
  end
end
