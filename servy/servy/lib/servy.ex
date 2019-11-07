defmodule Servy do
  def hello(name \\ "World!") do
    "Hello, #{name}!"
  end
end

IO.puts(Servy.hello("Bijan"))
