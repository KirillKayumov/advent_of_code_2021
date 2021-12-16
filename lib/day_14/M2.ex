defmodule Day14.M2 do
  def run_step(_result, letters, 40, _pairs), do: letters

  def run_step(result, letters, step, pairs) do
    acc =
      result
      |> Enum.reduce(%{result: %{}, letters: letters}, fn {key, pair_counts}, acc ->
        a_value = String.at(key, 0)
        b_value = String.at(key, 1)
        middle_value = pairs[key]

        new_a_value = a_value <> middle_value
        new_b_value = middle_value <> b_value

        new_result =
          acc.result
          |> Map.update(new_a_value, pair_counts, &(&1 + pair_counts))
          |> Map.update(new_b_value, pair_counts, &(&1 + pair_counts))

        new_letters =
          acc.letters
          |> Map.update(middle_value, pair_counts, &(&1 + pair_counts))

        %{acc | result: new_result, letters: new_letters}
      end)

    run_step(acc.result, acc.letters, step + 1, pairs)
  end

  def call do
    {:ok, input} = File.read("lib/inputs/day_14.txt")

    data =
      input
      |> String.trim()
      |> String.split("\n\n")

    [_template, pairs] = data

    pairs =
      for pair <- String.split(pairs, "\n"), into: %{} do
        [from, to] = String.split(pair, " -> ")

        {from, to}
      end

    run_step(
      %{
        "SC" => 1,
        "CV" => 1,
        "VH" => 2,
        "HK" => 1,
        "KH" => 1,
        "HV" => 2,
        "VS" => 1,
        "SH" => 1,
        "HP" => 1,
        "PV" => 2,
        "VC" => 1,
        "CN" => 1,
        "NB" => 1,
        "BK" => 1,
        "KB" => 1,
        "BP" => 1
      },
      "SCVHKHVSHPVCNBKBPVHV" |> String.codepoints() |> Enum.frequencies(),
      0,
      pairs
    )
  end
end
