# ChatGPT's parser
defmodule MapParser do
  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.reduce({nil, %{}}, fn line, {current_key, acc} ->
      case String.trim(line) do
        "" ->
          {current_key, acc}

        line ->
          case String.split(line, ~r/:|\n/, parts: 2) do
            [key, ""] ->
              {String.trim(key), acc}

            [values] when current_key != nil ->
              {current_key,
               Map.update(
                 acc,
                 current_key,
                 [parse_values(values)],
                 &([parse_values(values)] ++ &1)
               )}

            _ ->
              {current_key, acc}
          end
      end
    end)
    |> elem(1)
  end

  defp parse_values(values) do
    values
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end
end

defmodule Tools do
  def get_input do
    {:ok, str} = File.read("data.txt")
    MapParser.parse(str)
  end
end

# Part 2 is the exact same code, just merge the input
# This is O(N) so it runs in around 1s (input is around 6 * 10^7).
defmodule Part1 do
  def compute(map) do
    times = Tuple.to_list(hd(map["Time"]))
    distances = Tuple.to_list(hd(map["Distance"]))

    Enum.zip(times, distances)
    |> Enum.map(fn {t, d} ->
      0..t
      |> Enum.map(fn time ->
        time * (t - time) > d
      end)
      |> Enum.count(& &1)
    end)
    |> Enum.product()
  end
end

# Use math, O(1)
defmodule Part2 do
  def compute(map) do
    times = Tuple.to_list(hd(map["Time"]))
    distances = Tuple.to_list(hd(map["Distance"]))

    Enum.zip(times, distances)
    |> Enum.map(fn {t, d} ->
      det = :math.sqrt(t * t - 4 * d)
      r1 = (t + det) / 2
      r2 = (t - det) / 2
      trunc(:math.floor(r1) - :math.ceil(r2) + 1)
    end)
    |> Enum.product()
  end
end

Tools.get_input() |> Part2.compute() |> IO.puts()
