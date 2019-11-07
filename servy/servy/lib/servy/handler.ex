defmodule Servy.Handler do
  require Logger

  def handle(request) do
    request
    |> parse()
    |> rewrite_path()
    |> log()
    |> route()
    |> track()
    |> format_response()
  end

  def parse(request) do
    [method, path | _tail] = String.split(request)

    %{
      method: method,
      path: path,
      response_body: "",
      status: nil
    }
  end

  def rewrite_path(%{path: "/workouts"} = conn) do
    %{conn | path: "exercises"}
  end

  def rewrite_path(conn), do: conn

  def route(%{method: "GET", path: "/exercises"} = conn) do
    %{conn | response_body: "Squat, Bench, Deadlift"}
  end

  def route(%{method: "GET", path: "/exercises/" <> id} = conn) do
    %{conn | response_body: "Exercise #{id}"}
  end

  def route(%{method: "DELETE", path: "/exercises/" <> _id} = conn) do
    %{conn | response_body: "Deleting exercises is forbidden.", status: 403}
  end

  def route(%{method: "GET", path: "/programs"} = conn) do
    %{conn | response_body: "Starting Strength, StrongLifts, 5/3/1"}
  end

  def route(%{method: "GET", path: "/programs/" <> id} = conn) do
    %{conn | response_body: "Program #{id}"}
  end

  def route(conn) do
    %{
      conn
      | response_body: "#{conn.path} Not found",
        status: 404,
        status_reason: status_reason(404)
    }
  end

  def format_response(conn) do
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: #{byte_size(conn.response_body)}

    #{conn.response_body}
    """
  end

  defp log(conn) do
    conn_log = Enum.map_join(conn, ", ", fn {key, value} -> "#{key}: #{value}" end)
    Logger.info(conn_log)

    conn
  end

  defp status_reason(code) do
    reasons = %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }

    reasons[code]
  end

  defp track(%{status: 404, path: path} = conn) do
    IO.puts("Warning: #{path} is missing.")
    conn
  end

  defp track(conn), do: conn
end

request_exercises = """
GET /exercises HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request_programs = """
GET /programs HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response_exercises = Servy.Handler.handle(request_exercises)
response_programs = Servy.Handler.handle(request_programs)

IO.puts(response_exercises)
IO.puts(response_programs)
