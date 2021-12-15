defmodule Day13.M2 do
  def call do
    {:ok, input} = File.read("lib/inputs/day_13.txt")

    data =
      input
      |> String.trim()
      |> String.split("\n\n")

    [dots, foldings] = data

    dots =
      dots
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(fn row -> row |> String.split(",") |> Enum.map(&String.to_integer/1) end)

    foldings =
      foldings
      |> String.split("\n")
      |> Enum.map(fn row ->
        row
        |> String.split(" ")
        |> Enum.at(-1)
        |> String.split("=")
      end)

    width = dots |> Enum.map(fn [x, _] -> x end) |> Enum.max()
    height = dots |> Enum.map(fn [_, y] -> y end) |> Enum.max()

    sheet = Enum.map(0..height, fn _ -> Enum.map(0..width, fn _ -> "." end) end)
    sheet = Enum.reduce(dots, sheet, fn [x, y], acc -> List.replace_at(acc, y, acc |> Enum.at(y) |> List.replace_at(x, "#")) end)

    foldings
    |> Enum.reduce(%{sheet: sheet, width: width, height: height}, fn folding, data ->
      case folding do
        ["y", string_number] ->
          IO.puts("Folding y=#{string_number}")

          folding_number = String.to_integer(string_number)

          new_sheet =
            (folding_number + 1)..data.height
            |> Enum.reduce(data.sheet, fn second_row_index, acc ->
              first_row_index = folding_number - (second_row_index - folding_number)

              0..data.width
              |> Enum.reduce(acc, fn column_index, acc ->
                first_value = acc |> Enum.at(first_row_index) |> Enum.at(column_index)
                second_value = acc |> Enum.at(second_row_index) |> Enum.at(column_index)

                new_value =
                  cond do
                    first_value == "#" || second_value == "#" -> "#"
                    true -> "."
                  end

                acc |> List.replace_at(first_row_index, acc |> Enum.at(first_row_index) |> List.replace_at(column_index, new_value))
              end)
            end)
            |> Enum.slice(0, folding_number)

          %{data | sheet: new_sheet, height: folding_number - 1}

        ["x", string_number] ->
          IO.puts("Folding x=#{string_number}")

          folding_number = String.to_integer(string_number)

          new_sheet =
            (folding_number + 1)..data.width
            |> Enum.reduce(data.sheet, fn second_column_index, acc ->
              first_column_index = folding_number - (second_column_index - folding_number)

              0..data.height
              |> Enum.reduce(acc, fn row_index, acc ->
                first_value = acc |> Enum.at(row_index) |> Enum.at(first_column_index)
                second_value = acc |> Enum.at(row_index) |> Enum.at(second_column_index)

                new_value =
                  cond do
                    first_value == "#" || second_value == "#" -> "#"
                    true -> "."
                  end

                acc |> List.replace_at(row_index, acc |> Enum.at(row_index) |> List.replace_at(first_column_index, new_value))
              end)
            end)
            |> Enum.map(fn row -> Enum.slice(row, 0, folding_number) end)

          %{data | sheet: new_sheet, width: folding_number - 1}
      end
    end)
    |> tap(fn %{sheet: sheet} ->
      sheet
      |> Enum.each(fn row ->
        row
        |> Enum.each(fn col -> IO.write(col) end)

        IO.puts("")
      end)
    end)
  end
end
