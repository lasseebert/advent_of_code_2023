defmodule Advent.Day24 do
  @moduledoc """
  Day 24
  """

  alias Advent.Matrix

  @doc """
  Part 1
  """
  @spec part_1(String.t(), {integer, integer}) :: integer
  def part_1(input, test_area \\ {200_000_000_000_000, 400_000_000_000_000}) do
    input
    |> parse()
    |> find_test_area_intersections(test_area)
  end

  defp find_test_area_intersections(hails, test_area) do
    hails =
      hails
      |> Enum.map(fn {{px, py, _pz}, {vx, vy, _vz}} -> {{px, py}, {vx, vy}} end)
      # Change {pos, vel} to {pos_1, pos_2}
      |> Enum.map(fn {pos, vel} -> {pos, add(pos, vel)} end)

    for(h1 <- hails, h2 <- hails, h1 < h2, do: {h1, h2})
    |> Enum.count(fn {hail_1, hail_2} -> intersect_in_test_area?(hail_1, hail_2, test_area) end)
  end

  # https://en.wikipedia.org/wiki/Line%E2%80%93line_intersection#Given_two_points_on_each_line_segment
  #
  # t/factor is the time of intersection for hail 1
  # u/factor is the time of intersection for hail 2
  defp intersect_in_test_area?({{x1, y1}, {x2, y2}}, {{x3, y3}, {x4, y4}}, {min, max}) do
    factor = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)

    if factor == 0 do
      false
    else
      t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / factor
      u = ((x1 - x3) * (y1 - y2) - (y1 - y3) * (x1 - x2)) / factor

      x = x1 + t * (x2 - x1)
      y = y1 + t * (y2 - y1)

      t >= 0 and u >= 0 and x >= min and x <= max and y >= min and y <= max
    end
  end

  defp add({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}

  @doc """
  Part 2
  """
  @spec part_2(String.t()) :: integer
  def part_2(input) do
    hails = input |> parse()

    # We want to find {{px0, py0, pz0}, {vx0, vy0, vz0}} such that
    #
    # px0 + vx0 * ti = pxi + vxi * ti
    # py0 + vy0 * ti = pyi + vyi * ti
    # pz0 + vz0 * ti = pzi + vzi * ti
    #
    # For all i in 1..n (number of hails) and where ti is the time of intersection with hail i
    #
    # Taking the first hail stone as the reference point, we can rewrite the above as
    #
    # px0 + vx0 * t1 = px1 + vx1 * t1
    # py0 + vy0 * t1 = py1 + vy1 * t1
    # pz0 + vz0 * t1 = pz1 + vz1 * t1
    #
    # Isolating t1:
    #
    # t1 = (px0 - px1) / (vx1 - vx0)
    # t1 = (py0 - py1) / (vy1 - vy0)
    # t1 = (pz0 - pz1) / (vz1 - vz0)
    #
    # Which means that we can
    #
    # (px0 - px1) / (vx1 - vx0) = (py0 - py1) / (vy1 - vy0)
    # (px0 - px1) * (vy1 - vy0) = (py0 - py1) * (vx1 - vx0)
    # px0 * vy1 - px0 * vy0 - px1 * vy1 + px1 * vy0 = py0 * vx1 - py0 * vx0 - py1 * vx1 + py1 * vx0
    # py0 * vx0 - px0 * vy0 = py0 * vx1 - py1 * vx1 + py1 * vx0 - px0 * vy1 + px1 * vy1 - px1 * vy0
    #
    # Notice that the left side of the equation is the same for other hails, so if we calculate the same
    # for other hails we can set the right sides equal to each other:
    #
    # py0 * vx1 - py1 * vx1 + py1 * vx0 - px0 * vy1 + px1 * vy1 - px1 * vy0 =
    #   py0 * vx2 - py2 * vx2 + py2 * vx0 - px0 * vy2 + px2 * vy2 - px2 * vy0
    #
    # (vy2 - vy1) * px0 + (vx1 - vx2) * py0 + (py1 - py2) * vx0 + (px2 - px1) * vy0 =
    #   - py2 * vx2 + px2 * vy2 + py1 * vx1 - px1 * vy1
    #
    # This is a linear equation with four unknowns (px0, py0, vx0, vy0)
    #
    # We can expand this to six unknowns by adding the z axis. Also, we can
    # have three equations per hail stone pair (xy, xz, yz).
    #
    # So we can have six linear equations with six unknnowns using two pairs of hail stones (1-2 and 1-3).
    #
    # (vy2 - vy1) * px0 + (vx1 - vx2) * py0 + (py1 - py2) * vx0 + (px2 - px1) * vy0 =
    #   - py2 * vx2 + px2 * vy2 + py1 * vx1 - px1 * vy1
    # (vz2 - vz1) * px0 + (vx1 - vx2) * pz0 + (pz1 - pz2) * vx0 + (px2 - px1) * vz0 =
    #   - pz2 * vx2 + px2 * vz2 + pz1 * vx1 - px1 * vz1
    # (vy3 - vy1) * px0 + (vx1 - vx3) * py0 + (py1 - py3) * vx0 + (px3 - px1) * vy0 =
    #   - py3 * vx3 + px3 * vy3 + py1 * vx1 - px1 * vy1
    # (vz3 - vz1) * px0 + (vx1 - vx3) * pz0 + (pz1 - pz3) * vx0 + (px3 - px1) * vz0 =
    #   - pz3 * vx3 + px3 * vz3 + pz1 * vx1 - px1 * vz1
    # (vz2 - vz1) * py0 + (vy1 - vy2) * pz0 + (pz1 - pz2) * vy0 + (py2 - py1) * vz0 =
    #   - pz2 * vy2 + py2 * vz2 + pz1 * vy1 - py1 * vz1
    # (vz3 - vz1) * py0 + (vy1 - vy3) * pz0 + (pz1 - pz3) * vy0 + (py3 - py1) * vz0 =
    #   - pz3 * vy3 + py3 * vz3 + pz1 * vy1 - py1 * vz1
    #
    # Which gives this matrix:

    [hail_1, hail_2, hail_3] = Enum.take(hails, 3)
    {{px1, py1, pz1}, {vx1, vy1, vz1}} = hail_1
    {{px2, py2, pz2}, {vx2, vy2, vz2}} = hail_2
    {{px3, py3, pz3}, {vx3, vy3, vz3}} = hail_3

    a =
      Matrix.new([
        [vy2 - vy1, vx1 - vx2, 0, py1 - py2, px2 - px1, 0],
        [vz2 - vz1, 0, vx1 - vx2, pz1 - pz2, 0, px2 - px1],
        [vy3 - vy1, vx1 - vx3, 0, py1 - py3, px3 - px1, 0],
        [vz3 - vz1, 0, vx1 - vx3, pz1 - pz3, 0, px3 - px1],
        [0, vz2 - vz1, vy1 - vy2, 0, pz1 - pz2, py2 - py1],
        [0, vz3 - vz1, vy1 - vy3, 0, pz1 - pz3, py3 - py1]
      ])

    b = [
      -py2 * vx2 + px2 * vy2 + py1 * vx1 - px1 * vy1,
      -pz2 * vx2 + px2 * vz2 + pz1 * vx1 - px1 * vz1,
      -py3 * vx3 + px3 * vy3 + py1 * vx1 - px1 * vy1,
      -pz3 * vx3 + px3 * vz3 + pz1 * vx1 - px1 * vz1,
      -pz2 * vy2 + py2 * vz2 + pz1 * vy1 - py1 * vz1,
      -pz3 * vy3 + py3 * vz3 + pz1 * vy1 - py1 * vz1
    ]

    det = Matrix.det(a)

    # We only need to solve the first three
    px0 = Matrix.det(a |> Matrix.replace_column(0, b)) / det
    py0 = Matrix.det(a |> Matrix.replace_column(1, b)) / det
    pz0 = Matrix.det(a |> Matrix.replace_column(2, b)) / det

    sum = px0 + py0 + pz0
    sum_integer = trunc(sum)
    true = sum_integer == sum

    sum_integer
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_hail/1)
  end

  defp parse_hail(line) do
    line
    |> String.split("@", trim: true)
    |> Enum.map(&parse_coord/1)
    |> then(fn [pos, vel] -> {pos, vel} end)
  end

  defp parse_coord(coord) do
    coord
    |> String.split(",", trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
    |> then(fn [x, y, z] -> {x, y, z} end)
  end
end
