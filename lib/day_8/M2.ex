defmodule Day8.M2 do
  @digit_lines %{
    [5, 2] => "1",
    [5, 2, 0] => "7",
    [5, 3, 2, 1] => "4",
    [6, 4, 3, 2, 0] => "2",
    [6, 5, 3, 2, 0] => "3",
    [6, 5, 3, 1, 0] => "5",
    [6, 5, 4, 2, 1, 0] => "0",
    [6, 5, 4, 3, 1, 0] => "6",
    [6, 5, 3, 2, 1, 0] => "9",
    [6, 5, 4, 3, 2, 1, 0] => "8"
  }

  def generate_permutations([]), do: [[]]

  def generate_permutations(list) do
    for head <- list, tail <- generate_permutations(list -- [head]), do: [head | tail]
  end

  def get_digit_lines(mask, permutation) do
    mask
    |> String.codepoints()
    |> Enum.reduce([], fn mask_item, acc ->
      [Enum.find_index(permutation, &(&1 == mask_item)) | acc]
    end)
    |> Enum.sort(:desc)
  end

  def valid_mask?(digit_lines) do
    @digit_lines
    |> Map.keys()
    |> Enum.member?(digit_lines)
  end

  def find_permutation(masks, permutations) do
    [current_permutation | other_permutations] = permutations

    correct_permutation =
      Enum.all?(masks, fn mask ->
        mask |> get_digit_lines(current_permutation) |> valid_mask?()
      end)

    case correct_permutation do
      true -> current_permutation
      false -> find_permutation(masks, other_permutations)
    end
  end

  def call do
    {:ok, input} = File.read("lib/inputs/day_8.txt")
    permutations = generate_permutations(~w[a b c d e f g])

    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " | "))
    |> Enum.map(fn [a, b] -> {String.split(a, " "), String.split(b, " ")} end)
    |> Enum.reduce(0, fn {masks, digits}, acc ->
      permutation = find_permutation(masks, permutations)

      number =
        for digit <- digits, into: "" do
          @digit_lines[get_digit_lines(digit, permutation)]
        end
        |> String.to_integer()

      acc + number
    end)
  end
end
