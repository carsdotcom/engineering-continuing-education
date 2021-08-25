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

  PROBLEM:
  Fixed XOR
  Write a function that takes two equal-length buffers and produces their XOR combination.

  If your function works properly, then when you feed it the string: "1c0111001f010100061a024b53535009181c"

  ... after hex decoding, and when XOR'd against: "686974207468652062756c6c277320657965"

  ... should produce: "746865206b696420646f6e277420706c6179"
  """

  @doc """
  This is an example fn to serve the example test file. Please delete it and write your own ;)
  """
  @spec example_fn(String.t()) :: integer()
  def example_fn(string) do
    String.to_integer(string)
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
  alias CryptoPals.Set1.Challenge1

  describe "example_fn/1" do
    test "given a string, produces an integer" do
      assert Challenge1.example_fn("1") == 1
    end
  end
end
