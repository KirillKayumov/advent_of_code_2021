# 374061
defmodule Day10.M1 do
  def call do
    {:ok, input} = File.read("lib/inputs/day_10.txt")

    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.codepoints/1)
    |> Enum.reduce(0, fn brackets, acc ->
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

      acc +
        case result.corrupted_bracket do
          ")" -> 3
          "]" -> 57
          "}" -> 1197
          ">" -> 25137
          _ -> 0
        end
    end)
  end
end
