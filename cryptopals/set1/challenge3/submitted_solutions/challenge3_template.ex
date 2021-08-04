defmodule CryptoPals.Set1.Challenge3 do
  use Bitwise

  @moduledoc """
  Source: 'https://cryptopals.com/sets/1/challenges/3'

  Solution code should be written here.

  To run tests, paste the following into the commandline from the project root.
  ```bash
  elixir -r cryptopals/set1/challenge3/elixir_template/challenge3_template.ex
  ```

  When submitting, change the name of this file to reflect the names of those that participated in the solution. (ex: `Challenge3_mary_linda_harriet.ex`)
  Then create a PR to add your file to the repo under `cryptopals/set1/Challenge3/submitted_solutions/`.
  """

  @doc """
  This is an example fn to serve the example test file. Please delete it and write your own ;)
  """

  @average_word_length 5
  @space " "

  @spec re_xorcist(String.t()) :: integer()
  def re_xorcist(string) do
    all_characters = make_characters()
    decoded_binary = decode_from_binary(string)

    all_characters
    |> comparator(decoded_binary)
    |> score_messages()
    |> IO.inspect()
    |> Enum.sort_by(&elem(&1, 1), :desc)
  end

  @spec comparator([integer], integer()) :: String.t()
  defp comparator(all_characters, decoded_binary) do
    Enum.map(all_characters, fn character ->
      decoded_binary
      |> bxor(character)
      |> encoder()
    end)
  end

  @spec encoder(integer()) :: String.t()
  defp encoder(integer) do
    integer
    # why hex first?
    |> Integer.to_string(16)
    |> String.downcase()
    |> Base.decode16!(case: :lower)
    |> Base.encode64()
  end

  @spec decode_from_binary(String.t()) :: integer()
  defp decode_from_binary(string) do
    {int, _} = Integer.parse(string, 16)
    int
  end

  @spec make_characters() :: [integer()]
  defp make_characters do
    0..255
  end

  @spec score_messages([String.t()]) :: [{String.t(), float()}]
  defp score_messages(messages) do
    Enum.map(messages, fn message ->
      words = String.split(message, @space)

      word_sum =
        words
        |> Enum.map(&String.length/1)
        |> Enum.sum()

      word_length_average = word_sum / length(words)

      delta = abs(word_length_average - @average_word_length)

      {message, delta}
    end)
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

  describe "re_xorcist/1" do
    test "given a string, produces a decoded message" do
      message =
        Challenge3.re_xorcist(
          "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"
        )

      assert is_binary(message)
    end
  end
end
