defmodule CryptoPals.Set1.Challenge3 do
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
  @spec decode(String.t()) :: integer()
  def decode(string) do
    secret = String.to_integer(string, 16)

    0..255
    |> Enum.reduce(%{}, fn key_char, agg ->
      result = Bitwise.bxor(secret, key_char)

      agg[Integer.to_string(result)] = score(result)
    end)
    |> Enum.sort_by(&elem(&1, 1))
    |> hd()
  end

  def score(string), do: System.unique_integer()
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

  describe "decode/1" do
    test "given a string, produces an integer" do
      assert Challenge3.decode("11b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736") == 1
    end
  end
end
