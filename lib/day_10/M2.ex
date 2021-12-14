defmodule Day10.M2 do
  def call do
    {:ok, input} = File.read("lib/inputs/day_10.txt")

    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.codepoints/1)
    |> Enum.reduce([], fn brackets, acc ->
      result =
        Enum.reduce(brackets, %{stack: [], corrupted_bracket: nil}, fn
          _bracket, acc when not is_nil(acc.corrupted_bracket) ->
            acc

          bracket, acc ->
            case bracket do
              bracket when bracket in ~w/( [ { </ ->
                %{acc | stack: [bracket | acc.stack]}

              _ ->
                case acc.stack do
                  [] ->
                    %{acc | corrupted_bracket: bracket}

                  [stack_head | stack_tail] ->
                    cond do
                      bracket == ")" && stack_head == "(" ->
                        %{acc | stack: stack_tail}

                      bracket == "]" && stack_head == "[" ->
                        %{acc | stack: stack_tail}

                      bracket == "}" && stack_head == "{" ->
                        %{acc | stack: stack_tail}

                      bracket == ">" && stack_head == "<" ->
                        %{acc | stack: stack_tail}

                      true ->
                        %{acc | corrupted_bracket: bracket}
                    end
                end
            end
        end)

      case result.corrupted_bracket do
        nil ->
          number =
            result.stack
            |> Enum.reduce([], fn
              "(", acc -> [")" | acc]
              "[", acc -> ["]" | acc]
              "{", acc -> ["}" | acc]
              "<", acc -> [">" | acc]
            end)
            |> Enum.reverse()
            |> Enum.reduce(0, fn
              ")", acc -> acc * 5 + 1
              "]", acc -> acc * 5 + 2
              "}", acc -> acc * 5 + 3
              ">", acc -> acc * 5 + 4
            end)

          [number | acc]

        _ ->
          acc
      end
    end)
    |> Enum.sort()
    |> then(fn data ->
      Enum.at(data, div(length(data), 2))
    end)
  end
end
