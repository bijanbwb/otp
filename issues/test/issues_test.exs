defmodule IssuesTest do
  use ExUnit.Case

  alias Issues.CLI

  test "handles arguments for username and repository with a default count" do
    {username, repository, count} = CLI.parse_args(["elixir-lang", "elixir"])

    assert is_binary(username)
    assert is_binary(repository)
    assert is_integer(count)

    assert username == "elixir-lang"
    assert repository == "elixir"
    assert count = 4
  end

  test "handles argument for a custom count" do
    {_username, _repository, count} = CLI.parse_args(["elixir-lang", "elixir", "2"])

    assert is_integer(count)
    assert count = 2
  end

  test "handles -h and --help options by returning :help" do
    assert CLI.parse_args(["-h"]) == :help
    assert CLI.parse_args(["--help"]) == :help
  end

  test "sorts by descending order" do
    result =
      ["c", "a", "b"]
      |> fake_created_at_list()
      |> CLI.sort_by_descending_order()

    issues = for issue <- result, do: Map.get(issue, "created_at")

    assert(issues == ["c", "b", "a"])
  end

  defp fake_created_at_list(values) do
    for value <- values, do: %{"created_at" => value, "other_data" => "x"}
  end
end
