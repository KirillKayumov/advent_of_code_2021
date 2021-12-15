defmodule Day12.M2 do
  def dfs(_graph, "end", visited_nodes, special_node, paths_count) do
    cond do
      is_nil(special_node) -> paths_count + 1
      Map.get(visited_nodes, special_node) == 2 -> paths_count + 1
      true -> paths_count
    end
  end

  def dfs(graph, current_node, visited_nodes, special_node, paths_count) do
    # IO.inspect(current_node)

    graph
    |> Map.get(current_node)
    |> Enum.reduce(paths_count, fn node, acc ->
      cond do
        node == special_node && Map.get(visited_nodes, node) == 2 ->
          acc

        node != special_node && Map.has_key?(visited_nodes, node) ->
          acc

        true ->
          new_visited_nodes = if String.upcase(node) != node, do: Map.update(visited_nodes, node, 1, &(&1 + 1)), else: visited_nodes

          dfs(graph, node, new_visited_nodes, special_node, acc)
      end
    end)
  end

  def call do
    {:ok, input} = File.read("lib/inputs/day_12.txt")

    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.reduce(%{}, fn line, acc ->
      [from, to] = String.split(line, "-")

      acc
      |> then(fn acc ->
        cond do
          to == "start" ->
            acc |> Map.update(to, [from], fn list -> [from | list] end)

          from == "start" ->
            acc |> Map.update(from, [to], fn list -> [to | list] end)

          from == "end" ->
            acc |> Map.update(to, [from], fn list -> [from | list] end)

          to == "end" ->
            acc |> Map.update(from, [to], fn list -> [to | list] end)

          true ->
            acc
            |> Map.update(from, [to], fn list -> [to | list] end)
            |> Map.update(to, [from], fn list -> [from | list] end)
        end
      end)
    end)
    |> tap(fn acc ->
      IO.inspect(acc)
    end)
    |> then(fn graph ->
      graph
      |> Map.keys()
      |> Enum.filter(fn key ->
        case key do
          "start" -> false
          _ -> String.upcase(key) != key
        end
      end)
      |> Enum.reduce(0, fn special_node, acc ->
        acc + dfs(graph, "start", %{}, special_node, 0)
      end)
      |> then(fn result ->
        result + dfs(graph, "start", %{}, nil, 0)
      end)
    end)
  end
end
