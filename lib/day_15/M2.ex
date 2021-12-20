defmodule Day15.M2 do
  def get_neighbors({row_index, col_index}, data) do
    size = length(data) - 1

    top =
      case row_index do
        0 -> nil
        _ -> {row_index - 1, col_index}
      end

    right =
      case col_index do
        ^size -> nil
        _ -> {row_index, col_index + 1}
      end

    bottom =
      case row_index do
        ^size -> nil
        _ -> {row_index + 1, col_index}
      end

    left =
      case col_index do
        0 -> nil
        _ -> {row_index, col_index - 1}
      end

    [top, right, bottom, left] |> Enum.reject(&is_nil/1)
  end

  def bfs([], costs, _data), do: costs

  def bfs([queue_head | queue_tail], costs, data) do
    IO.inspect(length(queue_tail))

    result =
      queue_head
      |> get_neighbors(data)
      |> Enum.reduce(%{queue_tail: queue_tail, costs: costs}, fn {neighbor_row, neighbor_col} = neighbor, acc ->
        current_cost = costs |> Enum.at(elem(queue_head, 0)) |> Enum.at(elem(queue_head, 1))
        neighbor_cost = costs |> Enum.at(neighbor_row) |> Enum.at(neighbor_col)
        neighbor_tax = data |> Enum.at(neighbor_row) |> Enum.at(neighbor_col)
        new_neighbor_cost = current_cost + neighbor_tax

        cond do
          new_neighbor_cost < neighbor_cost ->
            new_queue_tail = acc.queue_tail ++ [neighbor]

            new_costs =
              acc.costs
              |> List.replace_at(
                neighbor_row,
                acc.costs |> Enum.at(neighbor_row) |> List.replace_at(neighbor_col, new_neighbor_cost)
              )

            %{acc | queue_tail: new_queue_tail, costs: new_costs}

          true ->
            acc
        end
      end)

    bfs(result.queue_tail, result.costs, data)
  end

  def call do
    {:ok, input} = File.read("lib/inputs/day_15.txt")

    data =
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(fn row -> row |> String.codepoints() |> Enum.map(&String.to_integer/1) end)

    data =
      data
      |> Enum.map(fn row ->
        1..4
        |> Enum.reduce([row], fn increment, acc ->
          original_row = Enum.at(acc, increment - 1)
          new_row = Enum.map(original_row, fn elem -> Enum.max([1, rem(elem + 1, 10)]) end)

          acc ++ [new_row]
        end)
        |> List.flatten()
      end)

    data =
      1..4
      |> Enum.reduce([data], fn increment, acc ->
        original_matrix = Enum.at(acc, increment - 1)

        new_matrix =
          original_matrix
          |> Enum.map(fn row ->
            row
            |> Enum.map(fn col ->
              Enum.max([1, rem(col + 1, 10)])
            end)
          end)

        acc ++ [new_matrix]
      end)

    data =
      data
      |> Enum.reduce([], fn matrix, acc ->
        Enum.concat(acc, matrix)
      end)

    costs =
      for row <- data do
        for _ <- row do
          10 ** 10
        end
      end

    costs = costs |> List.replace_at(0, costs |> Enum.at(0) |> List.replace_at(0, 0))

    queue = [{0, 0}]

    bfs(queue, costs, data)
    |> Enum.at(length(data) - 1)
    |> Enum.at(length(data) - 1)
  end
end
