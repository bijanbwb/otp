defmodule Issues.CLI do
  @moduledoc """
  Handle the command-line parsing and the dispatch to the various functions
  that generate a table of the last _n_ issues in a GitHub repository.
  """

  @default_count 4

  def run(argv), do: parse_args(argv)

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
    |> case do
      {[help: true], _argv, _errors} ->
        :help

      {_options, [username, repository, count], _errors} ->
        {username, repository, String.to_integer(count)}

      {_options, [username, repository], _errors} ->
        {username, repository, @default_count}

      _ ->
        :help
    end
  end
end
