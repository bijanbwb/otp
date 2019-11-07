defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse()
    |> route()
    |> format_response()
  end

  def parse(request) do
    [method, path | _tail] = String.split(request)

    %{
      method: method,
      path: path,
      response_body: ""
    }
  end

  def route(conn) do
    %{conn | response_body: "Squat, Bench, Deadlift"}
  end

  def format_response(conn) do
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: #{byte_size(conn.response_body)}

    #{conn.response_body}
    """
  end
end

request = """
GET /exercises HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)
