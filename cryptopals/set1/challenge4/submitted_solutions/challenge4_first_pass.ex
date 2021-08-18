defmodule CryptoPals.Set1.Challenge4 do
  use Bitwise

  @moduledoc """
  Source: 'https://cryptopals.com/sets/1/challenges/4'

  Solution code should be written here.

  To run tests, paste the following into the commandline from the project root.
  ```bash
  elixir -r cryptopals/set1/challenge4/elixir_template/challenge4_template.ex
  ```

  When submitting, change the name of this file to reflect the names of those that participated in the solution. (ex: `Challenge4_mary_linda_harriet.ex`)
  Then create a PR to add your file to the repo under `cryptopals/set1/Challenge4/submitted_solutions/`.

  PROBLEM:
  Detect single-character XOR
  One of the 60-character strings in this file (cryptopals/set1/challenge4/challenge_materials/challenge4.txt) has been encrypted by single-character XOR.

  Find it.

  (Your code from challenge #3 should help.)
  """

  @doc """
  This is an example fn to serve the example test file. Please delete it and write your own ;)
  """

  # Taken from this article https://www3.nd.edu/~busiforc/handouts/cryptography/letterfrequencies.html

  @file_path Path.expand(__DIR__) <> "/challenge4.txt"

  @spec xorcist() :: String.t()
  def xorcist do
    lines()
    |> Enum.map(&decode_hex_to_binary/1)
    |> Enum.flat_map(&evaluate/1)
    |> score_spaces()
    |> Enum.sort_by(fn {_list, score} -> score end)
    |> List.take(10)
    |> Enum.map(&elem(&1, 0))
    |> List.to_string()
  end

  defp evaluate(decoded_byte_list) do
    Enum.map(make_characters(), fn character ->
      Enum.map(decoded_byte_list, fn integer ->
        bxor(character, integer)
      end)
    end)
  end

  @spec lines() :: [[integer()]]
  defp lines do
    @file_path
    |> File.stream!([:line])
    |> Stream.map(&String.trim_trailing/1)
    |> Enum.to_list()
  end

  @make_characters MapSet.new(0..255)
  defp make_characters do
    # make each ascii character (each being a byte)
    @make_characters
  end

  @printable_characters MapSet.new(32..126)
  defp filter_printable(charlists) do
    Enum.filter(charlists, fn list ->
      Enum.all?(list, fn char ->
        char in @printable_characters
      end)
    end)
  end

  @spec decode_hex_to_binary(String.t()) :: [integer()]
  defp decode_hex_to_binary(string) do
    string
    |> Base.decode16!(case: :lower)
    |> :binary.bin_to_list()
  end

  @letters_sorted_by_frequency ~w(e a r i o t n s l c u d p m h g b f y w k v x z j q)
  @range 26..1
  @letter_scores @letters_sorted_by_frequency |> Enum.zip(@range) |> Map.new()

  @spec score(String.t()) :: {String.t(), non_neg_integer()}
  defp score(string) do
    {string,
     string
     |> String.graphemes()
     |> Enum.reduce(0, fn grapheme, running_total ->
       running_total + Map.get(@letter_scores, grapheme, 0)
     end)}
  end

  @average_word_length 4.7
  @spec score_spaces(List.t(List.t())) :: [{List.t(), integer()}]
  defp score_spaces(lists) do
    Enum.map(lists, fn list ->
      space_target = length(list) / (@average_word_length + 1)
      count = Enum.count(list, fn char -> char == 32 end)
      score = abs(count - space_target)

      {list, score}
    end)
  end
end

ExUnit.start()
ExUnit.configure(exclude: :pending, trace: true)

defmodule CryptoPals.Set1.Challenge4Test do
  @moduledoc """
  Tests for Cryptopals Challenge 1.
  For a submission to be considered "complete", all tests should pass.
  """

  use ExUnit.Case
  alias CryptoPals.Set1.Challenge4

  describe "xorcist/1" do
    test "given a file, produces list of strings" do
      Challenge4.xorcist()
      |> IO.inspect()
    end
  end
end
