defmodule CryptoPals.Set1.Challenge2 do
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
  @spec fixed_xor(String.t(), String.t()) :: String.t()
  def fixed_xor(a, b) do
    a = String.to_integer(a, 16)
    b = String.to_integer(b, 16)

    a
    |> Bitwise.bxor(b)
    |> Integer.to_string(16)
    |> String.downcase()
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

  describe "fixed_xor/2" do
    test "given a string, produces an integer" do
      assert Challenge2.fixed_xor(
        "1c0111001f010100061a024b53535009181c",
        "686974207468652062756c6c277320657965"
        ) == "746865206b696420646f6e277420706c6179"
    end
  end
end
