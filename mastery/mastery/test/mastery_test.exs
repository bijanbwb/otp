defmodule MasteryTest do
  use ExUnit.Case, async: false
  use QuizBuilders

  alias Mastery.Examples.Math
  alias MasteryPersistence.{Repo, Response}

  defp enable_persistence() do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  defp response_count() do
    Repo.aggregate(Response, :count, :id)
  end

  defp give_wrong_answer(session, _left, _right) do
    Mastery.answer_question(session, "wrong", &MasteryPersistence.record_response/2)
  end

  defp give_right_answer(session, left, right) do
    answer = (left + right) |> Integer.to_string()

    Mastery.answer_question(session, answer, &MasteryPersistence.record_response/2)
  end

  defp get_ints_from_question(question) do
    [left, right | _rest] =
      question
      |> String.replace(" ", "")
      |> String.split("+")
      |> Enum.map(&String.to_integer/1)

    {left, right}
  end

  setup do
    enable_persistence()

    :ok = Mastery.build_quiz(Math.quiz_fields())
    :ok = Mastery.add_template(Math.quiz().title, Math.template_fields())
    session = Mastery.take_quiz(Math.quiz().title, "email@example.com")

    {:ok, session: session}
  end

  test "Take a quiz, manage lifecycle and persist responses", context do
    question = Mastery.select_question(context[:session])
    assert is_binary(question)

    {left, right} = get_ints_from_question(question)
    assert is_integer(left) and is_integer(right)
    assert {new_question, false} = give_wrong_answer(context[:session], left, right)

    {left, right} = get_ints_from_question(new_question)
    assert {new_question, true} = give_right_answer(context[:session], left, right)

    {left, right} = get_ints_from_question(new_question)
    assert :finished = give_right_answer(context[:session], left, right)

    assert response_count() > 0
  end
end
