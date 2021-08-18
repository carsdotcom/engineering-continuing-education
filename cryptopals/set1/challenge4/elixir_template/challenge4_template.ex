defmodule CryptoPals.Set1.Challenge4 do
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
  @spec example_fn(String.t()) :: integer()
  def example_fn(string) do
    String.to_integer(string)
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

  describe "example_fn/1" do
    test "given a string, produces an integer" do
      assert Challenge4.example_fn("1") == 1
    end
  end
end
