defmodule Advent.MatrixTest do
  use Advent.Test.Case

  alias Advent.Matrix

  describe "det" do
    test "2x2" do
      matrix = Matrix.new([[1, 2], [3, 4]])
      assert Matrix.det(matrix) == -2
    end

    test "3x3" do
      matrix = Matrix.new([[3, 2, 3], [4, 5, 6], [7, 8, 9]])
      assert Matrix.det(matrix) == -6
    end

    test "4x4" do
      matrix = Matrix.new([[15, 2, 3, 4], [2, 3, 4, 5], [3, 3, 5, 6], [4, 5, 6, 7]])
      assert Matrix.det(matrix) == -28
    end
  end
end
