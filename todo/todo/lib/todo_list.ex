defmodule TodoList do
  def new(), do: %{entries: []}

  def add_entry(todo_list, date, title) do
    %{ todo_list | entries: [%{date: date, title: title} | todo_list.entries] }
  end

  def entries(todo_list, date) do
    %{ todo_list | entries: todo_list.entries |> Enum.filter(fn(todo) -> todo.date == date end) }
  end
end
