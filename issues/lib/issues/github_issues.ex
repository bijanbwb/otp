defmodule Issues.GithubIssues do
  require Logger

  @github_url Application.get_env(:issues, :github_url)
  @user_agent [{"User-agent", "Elixir bijanbwb@gmail.com"}]

  def fetch(username, repository) do
    Logger.info("Fetching #{username}'s project #{repository}.")

    require IEx
    IEx.pry()

    issues_url(username, repository)
    |> HTTPoison.get(@user_agent)
    |> handle_response()
  end

  def issues_url(username, repository) do
    "#{@github_url}/repos/#{username}/#{repository}/issues"
  end

  defp handle_response({_response, %HTTPoison.Response{status_code: status_code, body: body}}) do
    Logger.info("Got response: status code=#{status_code}.")
    Logger.debug(fn -> inspect(body) end)

    {
      status_code |> check_for_error(),
      body |> Jason.decode!()
    }
  end

  defp handle_response(_), do: :error

  defp check_for_error(200), do: :ok
  defp check_for_error(_status_code), do: :error
end
