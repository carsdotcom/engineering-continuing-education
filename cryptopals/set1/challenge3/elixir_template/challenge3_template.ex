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
  def bit_shifter(string) do
    # decode the string
    integer_list = string |> Base.decode16!(case: :lower) |> :binary.bin_to_list()

    make_characters()
    # |> Enum.take(10)
    |> Enum.map(fn character ->
      integer_list
      |> Enum.map(fn integer ->
        bxor(character, integer)
      end)
      |> List.to_string()
    end)
    |> IO.inspect(limit: :infinity)

    # XOR it against each possible character
    # create a string of equal length for each possible single character, and xor all at once
    # OR enumerate through each character of the string and xor it against a single ASCII character (0..255)

    # score the result set for "human-ness"
    # return the result with the "best" score
  end

  defp make_characters do
    # make each ascii character (each being a byte)
    0..255
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

  describe "bit_shifter/1" do
    test "given a string, produces an human readable sentence" do
      Challenge3.bit_shifter(
        "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"
      )
    end
  end
end
