defmodule CryptoPals.Set1.Challenge3.Weights do
  alias CryptoPals.Set1.Challenge3

  def run do
    for s <- -2..10, p <- -2..2, w <- -2..10 do
      [{char1, score1, message1}, {char2, score2, message2}] =
        Challenge3.re_xorcist(
          "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736",
          scrabble: s,
          printability: p,
          word_length: w
        )
        |> Enum.take(2)

      {score1 - score2, [s: s, p: p, w: w], {char1, char2, message1, message2}}
    end
    |> Enum.sort_by(&elem(&1, 0), :desc)
    |> Enum.take(20)
    # |> Enum.flat_map(fn {score, weights, messages} ->
    #   Enum.map(weights, fn {algo, weight} ->
    #     {algo, weight, score, messages}
    #   end)
    # end)
    # |> Enum.group_by(&elem(&1, 0), fn {_algo, weight, score, messages} ->
    #   {weight, score, messages}
    # end)
    # |> Enum.map(fn {k, v} ->
    #   {weight, instances} =
    #     v
    #     |> Enum.group_by(&elem(&1, 0), fn {_weight, score, messages} -> {score, messages} end)
    #     |> Map.to_list()
    #     |> Enum.sort_by(&length(elem(&1, 1)), :desc)
    #     |> List.first()

    #   instances =
    #     instances
    #     |> Enum.group_by(
    #       fn {_score, {char1, char2, message1, message2}} ->
    #         {char1, char2, message1, message2}
    #       end,
    #       fn {score, _messages} -> score end
    #     )

    #   {k, weight, instances}
    # end)
    |> IO.inspect()
  end
end

Code.require_file("solution.ex")
CryptoPals.Set1.Challenge3.Weights.run()
