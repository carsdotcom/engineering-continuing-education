defmodule CryptoPals.Set1.Challenge1 do
  @moduledoc """
  Source: 'https://cryptopals.com/sets/1/challenges/1'

  Solution code should be written here.

  To run tests, paste the following into the commandline from the project root.
  ```bash
  elixir -r cryptopals/set1/challenge1/submitted_solutions/ck_pw_p1.ex
  ```

  When submitting, change the name of this file to reflect the names of those that participated in the solution. (ex: `challenge1_mary_linda_harriet.ex`)
  Then create a PR to add your file to the repo under cryptopals/set1/challenge1/submitted_solutions/.
  """

  @doc """
  This is an example fn to serve the example test file. Please delete it and write your own ;)
  """
  def hex_string_to_base64_string(string) do
    string
    |> Base.decode16!(case: :lower)
    |> IO.inspect(label: :secrets)
    |> Base.encode64()
  end
end

ExUnit.start()
ExUnit.configure(exclude: :pending, trace: true)

defmodule CryptoPals.Set1.Challenge1Test do
  @moduledoc """
  Tests for Cryptopals Challenge 1.
  For a submission to be considered "complete", all tests should pass.
  """

  use ExUnit.Case
  alias CryptoPals.Set1.Challenge1

  describe "hex_string_to_base64_string/1" do
    test "given a hex string, produces an base64 string" do
      string =
        "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"

      result = "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"
      assert Challenge1.hex_string_to_base64_string(string) == result
    end
  end
end
