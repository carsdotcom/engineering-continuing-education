defmodule CryptoPals.Set1.Challenge2 do
  use Bitwise

  @moduledoc """
  Source: 'https://cryptopals.com/sets/1/challenges/2'

  Solution code should be written here.

  To run tests, paste the following into the commandline from the project root.
  ```bash
  elixir -r cryptopals/set1/challenge2/elixir_template/challenge2_template.ex
  ```

  When submitting, change the name of this file to reflect the names of those that participated in the solution. (ex: `challenge1_mary_linda_harriet.ex`)
  Then create a PR to add your file to the repo under `cryptopals/set1/challenge1/submitted_solutions/`.
  """

  @doc """
  This is an example fn to serve the example test file. Please delete it and write your own ;)
  """
  @comparison_string "686974207468652062756c6c277320657965"

  @spec xorcist(String.t()) :: String.t()
  def xorcist(string) do
    decoded_binary = decode_from_binary(string)
    decoded_comparison_binary = decode_from_binary(@comparison_string)

    decoded_binary
    |> bxor(decoded_comparison_binary)
    |> Integer.to_string(16)
    |> String.downcase()
  end

  @spec decode_from_binary(String.t()) :: integer()
  defp decode_from_binary(string) do
    {int, _} = Integer.parse(string, 16)
    int
  end
end

ExUnit.start()
ExUnit.configure(exclude: :pending, trace: true)

defmodule CryptoPals.Set1.Challenge2Test do
  @moduledoc """
  Tests for Cryptopals Challenge 1.
  For a submission to be considered "complete", all tests should pass.
  """

  use ExUnit.Case
  alias CryptoPals.Set1.Challenge2

  describe "xorcist/1" do
    test "given a string, produces an integer" do
      assert Challenge2.xorcist("1c0111001f010100061a024b53535009181c") ==
               "746865206b696420646f6e277420706c6179"
    end
  end
end
