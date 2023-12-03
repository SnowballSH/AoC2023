defmodule Tools do
  def get_input do
    {:ok, str} = File.read("data.txt")
    String.split(String.trim(str), "\n")
  end

  def parse_game(line) do
    [_, rest] = String.split(line, "Game ", parts: 2)
    [id, rest] = String.split(rest, ": ", parts: 2)

    games =
      rest
      |> String.split("; ")
      |> Enum.map(fn trial ->
        trial
        |> String.split(", ")
        |> Enum.map(fn info ->
          info
          |> String.split(" ", parts: 2, trim: true)
          |> case do
            [n, clr] -> {String.to_integer(n), clr}
          end
        end)
      end)

    {String.to_integer(id), games}
  end
end

defmodule Part1 do
  def compute(list) do
    list
    |> Enum.map(&Tools.parse_game/1)
    |> Enum.reduce(0, fn {id, games}, answer ->
      games
      |> Enum.map(fn trial ->
        trial
        |> Enum.reduce({0, 0, 0}, fn {n, clr}, {r, g, b} ->
          case clr do
            "red" -> {n, g, b}
            "green" -> {r, n, b}
            "blue" -> {r, g, n}
          end
        end)
        |> case do
          {r, g, b} ->
            r <= 12 and g <= 13 and b <= 14
        end
      end)
      |> Enum.all?()
      |> case do
        true ->
          answer + id

        false ->
          answer
      end
    end)
  end
end

defmodule Part2 do
  def compute(list) do
    list
    |> Enum.map(&Tools.parse_game/1)
    |> Enum.reduce(0, fn {_id, games}, answer ->
      games
      |> Enum.map(fn trial ->
        trial
        |> Enum.reduce({0, 0, 0}, fn {n, clr}, counter ->
          case clr do
            "red" -> {elem(counter, 0) + n, elem(counter, 1), elem(counter, 2)}
            "green" -> {elem(counter, 0), elem(counter, 1) + n, elem(counter, 2)}
            "blue" -> {elem(counter, 0), elem(counter, 1), elem(counter, 2) + n}
          end
        end)
      end)
      |> Enum.reduce({0, 0, 0}, fn {r, g, b}, {mr, mg, mb} ->
        {max(r, mr), max(g, mg), max(b, mb)}
      end)
      |> case do
        {mr, mg, mb} ->
          mr * mg * mb + answer
      end
    end)
  end
end

Tools.get_input() |> Part1.compute() |> IO.puts()
Tools.get_input() |> Part2.compute() |> IO.puts()
