defmodule Mastery.Boundary.QuizSession do
  @moduledoc """
  GenServer initializes with a tuple containing the `quiz` and the user `email`.

  Start a quiz session, select a question, and attempt answering the question
  until enough correct answers are given for mastery.

  ## Example Usage

  iex> {:ok, session} = GenServer.start_link(QuizSession, {Math.quiz(), "mathy@example.com"})
  {:ok, #PID<0.157.0>}
  iex> QuizSession.select_question(session)
  "0 + 7"
  iex> QuizSession.answer_question(session, "7")
  {"9 + 7", true}
  iex> QuizSession.answer_question(session, "16")
  :finished
  """
  alias Mastery.Core.{Response, Quiz}

  use GenServer

  # API

  def select_question(session) do
    GenServer.call(session, :select_question)
  end

  def answer_question(session, answer) do
    GenServer.call(session, {:answer_question, answer})
  end

  # init

  def init({quiz, email}) do
    {:ok, {quiz, email}}
  end

  # handle_call

  def handle_call(:select_question, _from, {quiz, email}) do
    quiz = Quiz.select_question(quiz)

    {:reply, quiz.current_question.asked, {quiz, email}}
  end

  def handle_call({:answer_question, answer}, _from, {quiz, email}) do
    quiz
    |> Quiz.answer_question(Response.new(quiz, email, answer))
    |> Quiz.select_question()
    |> maybe_finish(email)
  end

  defp maybe_finish(nil, _email), do: {:stop, :normal, :finished, nil}

  defp maybe_finish(quiz, email) do
    {:reply, {quiz.current_question.asked, quiz.last_response.correct}, {quiz, email}}
  end
end
