defmodule Mastery do
  @moduledoc """
  API for building a quiz and maintaining its state with a GenServer.

  _[Note: The usage below should work as advertised, but it's not intended as
  a working doctest.]_

  ## Example Usage

      iex> Mastery.build_quiz(Math.quiz_fields)
      :ok

      iex> Mastery.add_template(Math.quiz.title, Math.template_fields)
      :ok

      iex> session = Mastery.take_quiz(Math.quiz.title, "mathy@email.com")
      #PID<0.180.0>

      iex> Mastery.select_question(session)
      "7 + 0"

      iex> Mastery.answer_question(session, "wrong")
      {"0 + 9", false}

      iex> Mastery.answer_question(session, "9")
      {"6 + 1", true}

      iex> Mastery.answer_question(session, "7")
      :finished

      iex> Process.alive?(session)
      false
  """

  alias Mastery.Boundary.{TemplateValidator, QuizManager, QuizSession, QuizValidator}
  alias Mastery.Core.Quiz

  def build_quiz(fields) do
    with :ok <- QuizValidator.errors(fields),
         :ok <- GenServer.call(QuizManager, {:build_quiz, fields}),
         do: :ok,
         else: (error -> error)
  end

  def add_template(title, fields) do
    with :ok <- TemplateValidator.errors(fields),
         :ok <- GenServer.call(QuizManager, {:add_template, title, fields}),
         do: :ok,
         else: (error -> error)
  end

  def take_quiz(title, email) do
    with %Quiz{} = quiz <- QuizManager.lookup_quiz_by_title(title),
         {:ok, _} <- QuizSession.take_quiz(quiz, email),
         do: {title, email},
         else: (error -> error)
  end

  def select_question(session) do
    GenServer.call(session, :select_question)
  end

  def answer_question(session, answer) do
    GenServer.call(session, {:answer_question, answer})
  end
end
