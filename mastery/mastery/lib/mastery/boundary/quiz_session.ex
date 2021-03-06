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

  # Supervision

  def child_spec({quiz, email}) do
    %{
      id: {__MODULE__, {quiz.title, email}},
      start: {__MODULE__, :start_link, [{quiz, email}]},
      restart: :temporary
    }
  end

  def start_link({quiz, email}) do
    GenServer.start_link(__MODULE__, {quiz, email}, name: via({quiz.title, email}))
  end

  def via({_title, _email} = name) do
    {:via, Registry, {Mastery.Registry.QuizSession, name}}
  end

  def take_quiz(quiz, email) do
    DynamicSupervisor.start_child(Mastery.Supervisor.QuizSession, {__MODULE__, {quiz, email}})
  end

  # API

  def select_question(name) do
    GenServer.call(via(name), :select_question)
  end

  def answer_question(name, answer, persistence_fn) do
    GenServer.call(via(name), {:answer_question, answer, persistence_fn})
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

  def handle_call({:answer_question, answer, fun}, _from, {quiz, email}) do
    fun = fun || fn r, f -> f.(r) end
    response = Response.new(quiz, email, answer)

    fun.(response, fn r ->
      quiz
      |> Quiz.answer_question(r)
      |> Quiz.select_question()
    end)
    |> maybe_finish(email)
  end

  defp maybe_finish(nil, _email), do: {:stop, :normal, :finished, nil}

  defp maybe_finish(quiz, email) do
    {:reply, {quiz.current_question.asked, quiz.last_response.correct}, {quiz, email}}
  end
end
