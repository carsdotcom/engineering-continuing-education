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
  @letters_sorted_by_frequency ~w(e a r i o t n s l c u d p m h g b f y w k v x z j q)
  @range 26..1
  @letter_scores @letters_sorted_by_frequency |> Enum.zip(@range) |> Map.new()
  @file_path Path.expand(__DIR__) <> "/challenge4.txt"

  @spec run() :: binary()
  def run do
    @file_path
    |> File.stream!([:line])
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&decrypt/1)
    |> Enum.max_by(&take_score/1)
    |> elem(0)
  end

  @spec decrypt(binary()) :: binary()
  def decrypt(binary) do
    bytes = to_byte_list(binary)

    0..255
    |> Enum.map(fn key ->
      bytes
      |> Enum.reduce(<<>>, fn byte, string ->
        string <> <<bxor(byte, key)>>
      end)
      |> score()
    end)
    |> Enum.max_by(&take_score/1)
  end

  @spec to_byte_list(String.t()) :: list()
  defp to_byte_list(string) do
    {int, _} = Integer.parse(string, 16)
    case Integer.digits(int, 2) do
      bits when rem(length(bits), 8) == 0 -> bits
      bits ->
        padding = for _ <- 1..(8 - rem(length(bits), 8)), do: 0
        Enum.concat(padding, bits)
    end
    |> Enum.chunk_every(8)
    |> Enum.map(fn byte_chunk ->
      Integer.undigits(byte_chunk, 2)
    end)
  end

  @spec score(String.t()) :: {String.t(), non_neg_integer()}
  defp score(string) do
    {string, string
    |> String.graphemes()
    |> Enum.reduce(0, fn grapheme, running_total ->
      running_total + Map.get(@letter_scores, grapheme, 0)
    end)}
  end

  @spec take_score({binary(), integer()}) :: integer()
  defp take_score({_, score}), do: score
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

  describe "run/0" do
    test "does some cool stuff" do
      assert Challenge4.run() == "Now that the party is jumping\n"
    end
  end
end
