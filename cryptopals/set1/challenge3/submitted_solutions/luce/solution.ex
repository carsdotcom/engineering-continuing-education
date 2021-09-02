defmodule CryptoPals.Set1.Challenge3 do
  use Bitwise

  @moduledoc """
  Source: 'https://cryptopals.com/sets/1/challenges/3'

  Solution code should be written here.

  To run tests, paste the following into the commandline from the project root.
  ```bash
  elixir -r cryptopals/set1/challenge3/elixir_template/challenge3_template.ex
  ```

  When submitting, change the name of this file to reflect the names of those
  that participated in the solution. (ex: `Challenge3_mary_linda_harriet.ex`)
  Then create a PR to add your file to the repo under
  `cryptopals/set1/Challenge3/submitted_solutions/`.
  """

  @average_word_length 4.7

  # {char, number of tiles, tile point value}
  @scrabble [
    {'E', 12, 1},
    {'A', 9, 1},
    {'I', 8, 1},
    {'O', 8, 1},
    {'N', 6, 1},
    {'R', 6, 1},
    {'T', 6, 1},
    {'L', 4, 1},
    {'S', 4, 1},
    {'U', 4, 1},
    {'D', 4, 2},
    {'G', 3, 2},
    {'B', 2, 3},
    {'C', 2, 3},
    {'M', 2, 3},
    {'P', 2, 3},
    {'F', 2, 4},
    {'H', 2, 4},
    {'V', 2, 4},
    {'W', 2, 4},
    {'Y', 2, 4},
    {'K', 1, 5},
    {'J', 1, 8},
    {'X', 1, 8},
    {'Q', 1, 10},
    {'Z', 1, 10}
  ]

  @max_tile_score elem(hd(@scrabble), 1) / elem(hd(@scrabble), 2)

  # <<32>>
  @space " "

  @printability_weight 0
  @scrabble_weight 4
  @word_length_weight 1

  # TODO: adapt to byte stream

  @spec re_xorcist(String.t(), keyword()) :: list({integer(), float(), String.t()})
  def re_xorcist(string, weights \\ []) do
    bin = decode_hex_string_to_binary(string)

    for char <- list_all_characters() do
      bin
      |> xor_encrypt(char)
      |> score_message(weights)
    end
    |> normalize_scores()
    # |> apply_weights() # TODO:
    |> Enum.sort_by(&elem(&1, 1), :desc)
    # purely for pretty printing purposes:
    |> Enum.take(10)
    |> IO.inspect()
  end

  @spec xor_encrypt(binary(), byte()) :: {byte(), binary()}
  defp xor_encrypt(bin, char) do
    bin =
      for <<c <- bin>> do
        bxor(c, char)
      end
      |> encode_charlist_to_binary()

    {char, bin}
  end

  @spec encode_charlist_to_binary(charlist()) :: binary()
  defp encode_charlist_to_binary(chars), do: List.to_string(chars)

  @spec decode_hex_string_to_binary(String.t()) :: binary()
  defp decode_hex_string_to_binary(str), do: Base.decode16!(str, case: :lower)

  @spec list_all_characters() :: [byte()]
  defp list_all_characters, do: 0..255

  @spec to_list(tuple() | list()) :: list()
  defp to_list(tuple) when is_tuple(tuple), do: Tuple.to_list(tuple)
  defp to_list(list) when is_list(list), do: list

  @doc """
  Like Enum.zip/2 but concatenates the elements rather than pairing them in
  tuples. Useful if you want to append one or more elements to a list of lists
  in one pass.

  NB: the recursion and list concatenation seems like a poor performance choice,
  but that's literally how Erlang does it, so :shrug:.
  """
  @spec zip(tuple(), list(tuple() | list())) :: list(list())
  def zip(elems, accs) when is_tuple(elems) do
    zip(to_list(elems), accs)
  end

  def zip([elem_hd | elems], [acc_hd | accs]) do
    [to_list(acc_hd) ++ [elem_hd] | zip(elems, accs)]
  end

  @spec zip(list(), list(list()) | []) :: []
  def zip(_, []), do: []
  def zip([], _), do: []

  @doc """
  Like Enum.unzip/1, but unzips a list of tuples of arbitrary length, quitting
  when any tuple is exhausted. By the nature of its implementation, it also
  works for lists of lists.
      iex> CryptoPals.Set1.Challenge3.unzip([
      ...>   { 1 ,  2 ,  3 ,  4 },
      ...>   {"a", "b", "c", "d"},
      ...> ])
      [[1, "a"], [2, "b"], [3, "c"], [4, "d"]]
      iex> CryptoPals.Set1.Challenge3.unzip([
      ...>   { 1 ,  2 ,  3 ,  4 },
      ...>   {'A', 'B'          },
      ...>   {"a", "b", "c", "d"},
      ...> ])
      [[1, 'A', "a"], [2, 'B', "b"]]
  TODO: option to pad short tuples?
  TODO: option to output list of tuples?
  """
  @spec unzip(list(tuple() | list())) :: list(list())
  def unzip(tuples) do
    Enum.reduce(tuples, [], fn
      tuple, [] -> Enum.map(tuple, &[&1])
      tuple, acc -> zip(tuple, acc)
    end)
  end

  # DEBUG: many iterations version
  # @spec normalize_scores(list(tuple())) :: list(tuple())
  # defp normalize_scores(n_tuple_list) do
  #   n_tuple_list
  #   |> unzip()
  #   |> Enum.map(fn scores ->
  #     with min <- Enum.min(scores),
  #          max <- Enum.max(scores),
  #          d <- max - min do
  #       Enum.map(scores, fn s ->
  #         s / (max - min) - min
  #       end)
  #     end
  #   end)
  # end

  # :: [[min0, max0, mod0], [min1, max1, mod1], ..., [mod_n_min, mod_n_max, mod_n_score]]
  @spec compare_extrema([
          min :: float(),
          max :: float(),
          score :: float()
        ]) :: [
          min :: float(),
          max :: float()
        ]
  defp compare_extrema([min, max, score]) do
    [min(min, score), max(max, score)]
  end

  # extrema :: [[min0, max0], [min1, max1], ..., module_n_extrema]
  @spec collate_extrema(
          # n_tuple :: {mod0, mod1, ..., module_n_score}
          n_tuple :: tuple(),
          # acc :: [[min0, max0], [min1, max1], ..., module_n_extrema]
          acc ::
            list([
              min :: float(),
              max :: float()
            ])
        ) ::
          extrema ::
          list([
            min :: float(),
            max :: float()
          ])
  defp collate_extrema(n_tuple, acc) do
    Enum.map(zip(n_tuple, acc), &compare_extrema/1)
  end

  @spec normalize_score(
          min :: float(),
          max :: float(),
          score :: float()
        ) ::
          float()
  defp normalize_score(min, max, score) do
    score / (max - min) - min
  end

  @spec do_normalize_scores(
          # zipped_scores :: [[min0, max0, scores0], [min1, max1, scores1], ..., [module_n_extrema | module_n_scores]]
          zipped_scores :: [
            min :: float(),
            max :: float(),
            # scores :: [mod_n_score0, mod_n_score1, ..., mod_n_score255]
            scores :: list(float())
          ]
        ) :: list(float())
  defp do_normalize_scores([min, max, scores]) do
    Enum.map(scores, &normalize_score(min, max, &1))
  end

  @spec normalize_scores(
          # n_tuple_list :: [n_tuple0, n_tuple1, ..., char_scores_255]
          n_tuple_list :: list(tuple())
        ) :: list(tuple())
  defp normalize_scores(n_tuple_list) do
    extrema = Enum.reduce(n_tuple_list, &collate_extrema/2)
    Enum.map(zip(n_tuple_list, extrema), &do_normalize_scores/1)
  end

  # TODO: figure out how to reliably tag messages' scores so we can attch
  # weights to them AFTER they've been normalized; and we'd like to normalize
  # them in one pass rather than n passes (where n is number of scoring modules)

  # printability = Keyword.get(weights, :printability, @printability_weight)
  # scrabble = Keyword.get(weights, :scrabble, @scrabble_weight)
  # word_length = Keyword.get(weights, :word_length, @word_length_weight)
  # {printability, score_by_printability(message)},
  # {scrabble, score_by_scrabble(message)},
  # {word_length, score_by_word_length(message)}
  # {weights, _scores} = Enum.unzip(weighted_scores)

  # weights
  # |> Enum.map(&abs/1)
  # |> Enum.sum()
  # |> case do
  #   0 ->
  #     0

  #   total_weight ->
  #     weighted_scores
  #     |> Enum.map(fn {w, s} -> w * s end)
  #     |> Enum.sum()
  #     |> Kernel./(total_weight)
  # end

  defp score_message(message_maybe_tuple, weights \\ [])

  @spec score_message({byte(), binary()}, keyword()) :: {byte(), float(), binary()}
  defp score_message({char, message}, weights) do
    {char, score_message(message, weights), message}
  end

  @spec score_message(binary(), keyword()) :: float()
  defp score_message(message, weights) do
    {
      score_by_printability(message),
      score_by_scrabble(message),
      score_by_word_length(message)
    }
  end

  @spec score_by_printability(binary()) :: float()
  defp score_by_printability(message) do
    _percent_printable =
      message
      |> String.graphemes()
      |> Enum.filter(&String.printable?/1)
      |> Enum.count()
      |> Kernel./(String.length(message))
  end

  # this score is normalized LOCALLY, which is to say: with respect to its
  # potential range; it is NOT normalized across its total actual output for a
  # given dataset)
  @spec score_by_scrabble(binary()) :: float()
  defp score_by_scrabble(message) do
    message
    |> String.upcase(:ascii)
    |> String.to_charlist()
    |> Enum.map(&score_by_scrabble_tile/1)
    |> Enum.sum()
    |> Kernel./(String.length(message))
  end

  defp score_by_scrabble_tile(char) do
    finder = fn
      {[^char], freq, value} -> freq / value
      _ -> nil
    end

    (Enum.find_value(@scrabble, finder) || 0) / @max_tile_score
  end

  @spec score_by_word_length(binary()) :: float()
  defp score_by_word_length(message) do
    # HT: @jwharrow for the heuristic!

    word_list = String.split(message, @space)

    total_num_chars = String.length(message)
    sum_word_length = total_num_chars - length(word_list) + 1
    avg_word_length = sum_word_length / length(word_list)

    delta = abs(avg_word_length / @average_word_length - 1)
    normal = total_num_chars / @average_word_length - 1

    1 - delta / normal
  end
end

ExUnit.start()
ExUnit.configure(exclude: :pending, trace: true)

defmodule CryptoPals.Set1.Challenge3Test do
  @moduledoc """
  Tests for Cryptopals Challenge 3.
  For a submission to be considered "complete", all tests should pass.
  """

  use ExUnit.Case
  alias CryptoPals.Set1.Challenge3

  describe "re_xorcist/1" do
    test "given a string, produces a decoded message" do
      {_char, _score, message} =
        Challenge3.re_xorcist(
          "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"
        )
        |> List.first()

      assert is_binary(message)
      assert message == "Cooking MC's like a pound of bacon"
    end
  end
end
