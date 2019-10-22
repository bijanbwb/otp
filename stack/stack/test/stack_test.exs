defmodule StackTest do
  use ExUnit.Case

  describe "Stack" do
    setup do
      stack = Stack.start()

      {:ok, stack: stack}
    end

    test "push an item onto an empty stack", _context do
      assert Stack.push(1) == :ok
    end

    test "push an item onto a non-empty stack", _context do
      assert Stack.push(1) == :ok
      assert Stack.push(2) == :ok
    end

    test "pop an item off an empty stack", _context do
      assert Stack.pop() == nil
    end

    test "pop an item off a non-empty stack", _context do
      assert Stack.push(1) == :ok
      assert Stack.pop() == 1
    end

    test "peek at an empty stack", _context do
      assert Stack.peek() == nil
    end

    test "peek at a non-empty stack", _context do
      assert Stack.push(1) == :ok
      assert Stack.peek() == 1
    end

    test "peek at a non-empty stack", _context do
      assert Stack.push(1) == :ok
      assert Stack.push(2) == :ok
      assert Stack.peek() == 2
      assert Stack.pop() == 2
      assert Stack.peek() == 1
      assert Stack.pop() == 1
      assert Stack.peek() == nil
    end
  end
end
