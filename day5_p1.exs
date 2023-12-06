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

defmodule Part1 do
  def compute(map) do
    seeds =
      hd(map["seeds"])
      |> Tuple.to_list()

    names = [
      "seed-to-soil map",
      "soil-to-fertilizer map",
      "fertilizer-to-water map",
      "water-to-light map",
      "light-to-temperature map",
      "temperature-to-humidity map",
      "humidity-to-location map"
    ]

    names
    |> Enum.reduce(seeds, fn name, acc ->
      mp = map[name]

      acc
      |> Enum.map(fn seed ->
        mp
        |> Enum.map(fn {dest, source, r} ->
          if source <= seed and seed < source + r do
            {true, dest + (seed - source)}
          else
            {false, seed}
          end
        end)
        |> Enum.find({true, seed}, fn {b, _} -> b end)
        |> case do
          {_, dest} ->
            dest
        end
      end)
    end)
    |> Enum.min()
  end
end

Tools.get_input() |> Part1.compute() |> IO.puts()
