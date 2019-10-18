defmodule ExerciseTest do
  use ExUnit.Case

  alias Fitbotp.Core.Exercise

  describe "Exercise" do
    test "constructor creates a new Exercise struct" do
      exercise = Exercise.new("🏋", "Barbell Squat", 5, 1, 45)

      assert !is_nil(exercise.datetime)
      assert exercise.icon == "🏋"
      assert exercise.name == "Barbell Squat"
      assert exercise.reps == 5
      assert exercise.sets == 1
      assert exercise.weight == 45
    end
  end
end
