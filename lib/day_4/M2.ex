defmodule Day4.M2 do
  def winning_row?(bingo) do
    bingo
    |> Enum.reduce(false, fn
      [true, true, true, true, true], _ -> true
      _, acc -> acc
    end)
  end

  def winning_column?(bingo) do
    0..(length(bingo) - 1)
    |> Enum.reduce(false, fn column_index, acc ->
      column =
        0..(length(bingo) - 1)
        |> Enum.map(fn row_index -> bingo |> Enum.at(row_index) |> Enum.at(column_index) end)

      case column do
        [true, true, true, true, true] -> true
        _ -> acc
      end
    end)
  end

  def calculate_sum(winning_matrix, winning_bingo) do
    0..(length(winning_matrix) - 1)
    |> Enum.reduce(0, fn row_index, acc ->
      acc +
        Enum.reduce(0..(length(winning_matrix) - 1), 0, fn column_index, acc ->
          case winning_bingo |> Enum.at(row_index) |> Enum.at(column_index) do
            false -> acc + (winning_matrix |> Enum.at(row_index) |> Enum.at(column_index))
            true -> acc
          end
        end)
    end)
  end

  def call do
    {:ok, input} = File.read("lib/inputs/day_4.txt")

    data =
      input
      |> String.trim()
      |> String.split("\n\n")

    numbers =
      data
      |> Enum.at(0)
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    matrices =
      data
      |> Enum.slice(1, length(data))
      |> Enum.map(fn matrix ->
        matrix
        |> String.split("\n")
        |> Enum.map(fn row ->
          [
            row |> String.slice(0, 2) |> String.trim() |> String.to_integer(),
            row |> String.slice(3, 2) |> String.trim() |> String.to_integer(),
            row |> String.slice(6, 2) |> String.trim() |> String.to_integer(),
            row |> String.slice(9, 2) |> String.trim() |> String.to_integer(),
            row |> String.slice(12, 2) |> String.trim() |> String.to_integer()
          ]
        end)
      end)

    bingos =
      matrices
      |> Enum.map(fn matrix ->
        matrix
        |> Enum.map(fn row ->
          row
          |> Enum.map(fn _ -> false end)
        end)
      end)

    winning_bingo_info =
      numbers
      |> Enum.reduce(
        %{
          bingos: bingos,
          winning_info: []
        },
        fn number, acc ->
          cond do
            # !is_nil(acc.winning_number) ->
            #   acc

            true ->
              new_bingos =
                acc.bingos
                |> Enum.with_index()
                |> Enum.map(fn {bingo, bingo_index} ->
                  bingo
                  |> Enum.with_index()
                  |> Enum.map(fn {row, row_index} ->
                    row
                    |> Enum.with_index()
                    |> Enum.map(fn {column, column_index} ->
                      case matrices
                           |> Enum.at(bingo_index)
                           |> Enum.at(row_index)
                           |> Enum.at(column_index) do
                        ^number -> true
                        _ -> column
                      end
                    end)
                  end)
                end)

              new_winning_bingo_index =
                new_bingos
                |> Enum.with_index()
                |> Enum.reduce(nil, fn {bingo, bingo_index}, acc ->
                  cond do
                    !is_nil(acc) -> acc
                    winning_row?(bingo) || winning_column?(bingo) -> bingo_index
                    true -> acc
                  end
                end)

              case new_winning_bingo_index do
                nil ->
                  %{acc | bingos: new_bingos}

                _ ->
                  winning_number = number

                  %{
                    acc
                    | bingos: new_bingos,
                      winning_info: [
                        %{
                          winning_number: winning_number,
                          winning_bingo_index: new_winning_bingo_index
                        }
                        | acc.winning_info
                      ]
                  }
              end
          end
        end
      )

    require IEx
    IEx.pry()
    # winning_bingo = Enum.at(winning_bingo_info.bingos, winning_bingo_info.winning_bingo_index)
    # winning_matrix = Enum.at(matrices, winning_bingo_info.winning_bingo_index)

    # winning_bingo_info.winning_number * calculate_sum(winning_matrix, winning_bingo)
  end
end
