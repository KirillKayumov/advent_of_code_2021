defmodule Day12.M1 do
  # def bfs(_graph, "end", _visited_nodes, [], paths_count) do
  #   IO.inspect("current_node = end")
  #   IO.inspect("queue = []")
  #   IO.puts("")

  #   paths_count + 1
  # end

  # def bfs(graph, "end", visited_nodes, queue, paths_count) do
  #   IO.inspect("current_node = end")
  #   IO.inspect("queue = #{inspect(queue)}")
  #   IO.puts("")

  #   [new_current_node | new_queue] = queue

  #   bfs(graph, new_current_node, visited_nodes, new_queue, paths_count + 1)
  # end

  # def bfs(graph, current_node, visited_nodes, queue, paths_count) do
  #   new_queue =
  #     graph
  #     |> Map.get(current_node)
  #     |> Enum.reduce(queue, fn node, acc ->
  #       cond do
  #         MapSet.member?(visited_nodes, node) -> acc
  #         node == "start" -> acc
  #         true -> acc ++ [node]
  #       end
  #     end)

  #   new_visited_nodes = if String.upcase(current_node) != current_node, do: MapSet.put(visited_nodes, current_node), else: visited_nodes

  #   IO.inspect("current_node = #{current_node}")
  #   IO.inspect("queue = #{inspect(new_queue)}")
  #   IO.puts("")

  #   case new_queue do
  #     [] ->
  #       paths_count

  #     [new_current_node | new_queue] ->
  #       bfs(graph, new_current_node, new_visited_nodes, new_queue, paths_count)
  #   end
  # end

  def dfs(_graph, "end", _visited_nodes, paths_count) do
    IO.inspect("end")
    paths_count + 1
  end

  def dfs(graph, current_node, visited_nodes, paths_count) do
    IO.inspect(current_node)

    graph
    |> Map.get(current_node)
    |> Enum.reduce(paths_count, fn node, acc ->
      cond do
        MapSet.member?(visited_nodes, node) ->
          acc

        node == "start" ->
          acc

        true ->
          new_visited_nodes = if String.upcase(node) != node, do: MapSet.put(visited_nodes, node), else: visited_nodes

          dfs(graph, node, new_visited_nodes, acc)
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
      |> Map.update(from, [to], fn list -> [to | list] end)
      |> Map.update(to, [from], fn list -> [from | list] end)
    end)
    |> tap(fn acc ->
      IO.inspect(acc)
    end)
    |> dfs("start", MapSet.new(), 0)
  end
end
