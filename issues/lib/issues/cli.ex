defmodule Issues.CLI do
  @moduledoc """
  Handle the command-line parsing and the dispatch to the various functions
  that generate a table of the last _n_ issues in a GitHub repository.
  """

  alias Issues.GithubIssues
  alias Issues.TableFormatter

  @default_count 4

  def main(argv) do
    argv
    |> parse_args()
    |> process_args()
  end

  @doc """
  `argv` can be `-h` or `--help`, which returns `:help`.

  Otherwise, it is a GitHub `username`, `repository` name, and [optionally]
  the number of entries to format.

  Returns a tuple of `{username, repository, count}`, or `:help`.
  """
  def parse_args(argv) do
    parser_options = [
      aliases: [h: :help],
      switches: [help: :boolean]
    ]

    argv
    |> OptionParser.parse(parser_options)
    |> elem(1)
    |> args_to_internal_representation()
  end

  defp args_to_internal_representation([username, repository, count]) do
    {username, repository, String.to_integer(count)}
  end

  defp args_to_internal_representation([username, repository]) do
    {username, repository, @default_count}
  end

  defp args_to_internal_representation(_args) do
    :help
  end

  def process_args(:help) do
    IO.puts("Usage: issues <username> <repository> <count>")

    System.halt(0)
  end

  def process_args({username, repository, count}) do
    GithubIssues.fetch(username, repository)
    |> decode_response()
    |> sort_by_descending_order()
    |> last(count)
    |> TableFormatter.print_table_for_columns(["number", "created_at", "title"])
  end

  defp decode_response({:ok, body}), do: body

  defp decode_response({:error, error}) do
    IO.puts("Error fetching from GitHub: #{error["message"]}")

    System.halt(2)
  end

  def sort_by_descending_order(list_of_issues) do
    list_of_issues
    |> Enum.sort(fn i1, i2 ->
      i1["created_at"] >= i2["created_at"]
    end)
  end

  def last(list, count) do
    list
    |> Enum.take(count)
    |> Enum.reverse()
  end
end
