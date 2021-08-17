defmodule CryptoPals.Set1.Challenge3 do
  use Bitwise
  @moduledoc """
  Source: 'https://cryptopals.com/sets/1/challenges/3'
  """

  # Taken from this article https://www3.nd.edu/~busiforc/handouts/cryptography/letterfrequencies.html
  @letters_sorted_by_frequency ~w(e a r i o t n s l c u d p m h g b f y w k v x z j q)
  @range 26..1
  @letter_scores @letters_sorted_by_frequency |> Enum.zip(@range) |> Map.new()

  @spec decrypt() :: integer()
  def decrypt do
    bytes = to_byte_list("1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736")

    0..255
    |> Enum.map(fn key ->
      bytes
      |> Enum.reduce(<<>>, fn byte, string ->
        string <> <<bxor(byte, key)>>
      end)
      |> score()
    end)
    |> Enum.max_by(fn {_decoded_string, score} -> score end)
    |> elem(0)
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
end

ExUnit.start()
ExUnit.configure(exclude: :pending, trace: true)

defmodule CryptoPals.Set1.Challenge3Test do
  @moduledoc """
  Tests for Cryptopals Challenge 1.
  For a submission to be considered "complete", all tests should pass.
  """

  use ExUnit.Case
  alias CryptoPals.Set1.Challenge3

  describe "decrypt/0" do
    test "returns a string with only English characters" do
      assert Challenge3.decrypt()
        |> String.replace(~r|\s+|, "")
        |> String.to_charlist()
        |> Enum.all?(fn char -> char in ?A..?z || char end)
    end

    test "example string returns the secret message" do
      assert "Cooking MC's like a pound of bacon" == Challenge3.decrypt()
    end
  end
end
