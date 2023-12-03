defmodule Tools do
  def get_input do
    {:ok, str} = File.read("data.txt")
    String.split(String.trim(str), "\n")
  end
end

defmodule Part1 do
  def compute(list) do
    list
    |> Enum.reduce(0, fn x, acc ->
      x
      |> String.to_charlist()
      |> Enum.filter(&(&1 in ?0..?9))
      |> Enum.map(&(&1 - ?0))
      |> case do
        [first | _] = digits ->
          last = List.last(digits)
          acc + first * 10 + last

        _ ->
          acc
      end
    end)
  end
end

defmodule Part2 do
  def compute(list) do
    list
    |> Enum.reduce(0, fn x, acc ->
      x
      |> process
      |> case do
        [first | _] = digits ->
          last = List.last(digits)
          acc + first * 10 + last

        _ ->
          acc
      end
    end)
  end

  def process("") do
    []
  end

  def process(s) do
    rest = process(String.slice(s, 1..-1))

    case Integer.parse(String.first(s)) do
      {n, _} ->
        [n | rest]

      _ ->
        cond do
          String.starts_with?(s, "one") ->
            [1 | rest]

          String.starts_with?(s, "two") ->
            [2 | rest]

          String.starts_with?(s, "three") ->
            [3 | rest]

          String.starts_with?(s, "four") ->
            [4 | rest]

          String.starts_with?(s, "five") ->
            [5 | rest]

          String.starts_with?(s, "six") ->
            [6 | rest]

          String.starts_with?(s, "seven") ->
            [7 | rest]

          String.starts_with?(s, "eight") ->
            [8 | rest]

          String.starts_with?(s, "nine") ->
            [9 | rest]

          true ->
            rest
        end
    end
  end
end

Tools.get_input() |> Part1.compute() |> IO.puts()
Tools.get_input() |> Part2.compute() |> IO.puts()
