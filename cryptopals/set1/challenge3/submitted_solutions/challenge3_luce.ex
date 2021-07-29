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
  # <<32>>
  @space " "

  @spec re_xorcist(String.t()) :: String.t()
  def re_xorcist(string) do
    bin = decode_hex_string_to_binary(string)

    list_all_characters()
    |> Enum.map(&xor_encrypt(bin, &1))
    |> Enum.map(&score_message/1)
    |> Enum.sort_by(&elem(&1, 1), :asc)
    # purely for pretty printing purposes
    |> Enum.take(26)
    |> IO.inspect()
    |> List.first()
    |> elem(2)
  end

  @spec xor_encrypt(binary(), byte()) :: {byte(), binary()}
  defp xor_encrypt(bin, char) do
    bin =
      bin
      |> decode_binary_to_charlist()
      |> Enum.map(&bxor(&1, char))
      |> encode_charlist_to_binary()

    {char, bin}
  end

  @spec encode_charlist_to_binary(charlist()) :: binary()
  defp encode_charlist_to_binary(chars), do: List.to_string(chars)

  @spec decode_binary_to_charlist(binary()) :: charlist()
  defp decode_binary_to_charlist(bin), do: String.to_charlist(bin)

  @spec decode_hex_string_to_binary(String.t()) :: binary()
  defp decode_hex_string_to_binary(str), do: Base.decode16!(str, case: :lower)

  @spec list_all_characters() :: [byte()]
  defp list_all_characters, do: 0..255

  @spec score_message({byte(), binary()}) :: {byte(), float(), binary()}
  defp score_message({char, message}), do: {char, score_message(message), message}

  @spec score_message(binary()) :: float()
  defp score_message(message) do
    weighted_scores = [
      {2, score_by_printability(message)},
      {1, score_by_word_length(message)}
    ]

    # TODO: score by more criteria and aggregate a message's scores

    {weights, _scores} = Enum.unzip(weighted_scores)

    agg_score =
      weighted_scores
      |> Enum.map(fn {w, s} -> w * s end)
      |> Enum.sum()
      |> Kernel./(Enum.sum(weights))

    agg_score
  end

  @spec score_by_printability(binary()) :: float()
  defp score_by_printability(message) do
    case List.ascii_printable?(String.to_charlist(message)) do
      true -> 0.0
      false -> 1.0
    end
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

    delta / normal
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
      message =
        Challenge3.re_xorcist(
          "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"
        )

      assert is_binary(message)
      assert message == "Cooking MC's like a pound of bacon"
    end
  end
end
