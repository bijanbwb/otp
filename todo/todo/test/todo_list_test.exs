defmodule TodoListTest do
  use ExUnit.Case

  test "creates a new todo list" do
    todo_list =
      TodoList.new()

    assert todo_list == %{entries: []}
  end

  test "adds a new entry to the list" do
    todo =
      %{date: Date.utc_today(), title: "First"}

    todo_list =
      TodoList.new()
      |> TodoList.add_entry(todo.date, todo.title)

    assert todo_list == %{entries: [todo]}
  end

  test "adds multiple entries to the list" do
    todo1 =
      %{date: Date.utc_today(), title: "First"}

    todo2 =
      %{date: Date.utc_today(), title: "Second"}

    todo_list =
      TodoList.new()
      |> TodoList.add_entry(todo1.date, todo1.title)
      |> TodoList.add_entry(todo2.date, todo2.title)

    assert todo_list == %{entries: [todo2, todo1]}
  end

  test "lists entries for a given date" do
    todo1 =
      %{date: ~D[2020-01-01], title: "Found"}

    todo2 =
      %{date: ~D[2020-01-02], title: "Not Found"}

    todo_list =
      TodoList.new()
      |> TodoList.add_entry(todo1.date, todo1.title)
      |> TodoList.add_entry(todo2.date, todo2.title)
      |> TodoList.entries(~D[2020-01-01])

    assert todo_list == %{entries: [todo1]}
  end
end
