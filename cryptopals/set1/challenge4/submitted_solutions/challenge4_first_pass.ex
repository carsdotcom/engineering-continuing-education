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

  # Taken from this article https://www3.nd.edu/~busiforc/handouts/cryptography/letterfrequencies.html

  @file_path Path.expand(__DIR__) <> "/challenge4.txt"

  @spec xorcist() :: String.t()
  def xorcist do
    lines()
    |> Enum.map(&decode_hex_to_binary/1)
    |> Enum.flat_map(&evaluate/1)
    |> Enum.sort_by(fn {_character, _binary, score} -> score end, :desc)
    |> Enum.take(10)
  end

  defp evaluate(decoded_byte_list) do
    Enum.map(make_characters(), fn character ->
      Enum.map(decoded_byte_list, fn integer ->
        bxor(character, integer)
      end)
      |> List.to_string()
      |> then(fn binary -> {character, binary, score_by_scrabble(binary)} end)
    end)
    |> Enum.filter(fn {_character, binary, _score} -> String.printable?(binary) end)
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
