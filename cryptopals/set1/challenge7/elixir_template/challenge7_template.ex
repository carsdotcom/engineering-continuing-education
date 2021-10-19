defmodule CryptoPals.Set1.Challenge7 do
  @moduledoc """
  Source: 'https://cryptopals.com/sets/1/challenges/7'

  Solution code should be written here.

  To run tests, paste the following into the commandline from the project root.
  ```bash
  elixir -r cryptopals/set1/challenge7/elixir_template/challenge7_template.ex
  ```

  When submitting, change the name of this file to reflect the names of those that participated in the solution. (ex: `Challenge7_mary_linda_harriet.ex`)
  Then create a PR to add your file to the repo under `cryptopals/set1/challenge7/submitted_solutions/`.

  PROBLEM:

  AES in ECB mode

  The Base64-encoded content in cryptopals/set1/challenge7/challenge_materials/7.txt has been encrypted via AES-128 in ECB mode under the key

  "YELLOW SUBMARINE".

  (case-sensitive, without the quotes; exactly 16 characters; I like "YELLOW SUBMARINE" because it's exactly 16 bytes long, and now you do too).

  Decrypt it. You know the key, after all.

  Easiest way: use OpenSSL::Cipher and give it AES-128-ECB as the cipher.
  Do this with code.

  You can obviously decrypt this using the OpenSSL command-line tool, but we're having you get ECB working in code for a reason. You'll need it a lot later on, and not just for attacking ECB.

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

defmodule CryptoPals.Set1.Challenge7Test do
  @moduledoc """
  Tests for Cryptopals Challenge 7.
  For a submission to be considered "complete", all tests should pass.
  """

  use ExUnit.Case
  alias CryptoPals.Set1.Challenge7

  describe "example_fn/1" do
    test "given a string, produces an integer" do
      assert Challenge7.example_fn("1") == 1
    end
  end
end
