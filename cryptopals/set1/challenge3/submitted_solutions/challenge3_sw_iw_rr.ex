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


  "Hello" -> xor(a, ??) -> "1b3737...

  PROBLEM:
  Single-byte XOR cipher
  The hex encoded string: "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"
  ... has been XOR'd against a single character. Find the key, decrypt the message.

  You can do this by hand. But don't: write code to do it for you.

  How? Devise some method for "scoring" a piece of English plaintext. Character frequency is a good metric. Evaluate each output and choose the one with the best score.
  """

  @doc """
  This is an example fn to serve the example test file. Please delete it and write your own ;)
  """

  @spec decrypt(String.t()) :: integer()
  def decrypt(string) do
    decoded_binary =
      string
      |> Base.decode16!(case: :lower)
      |> to_charlist()

    Enum.reduce(32..127, [], fn char, agg ->
      result =
        decoded_binary
        |> Enum.map(&Bitwise.bxor(&1, char))
        |> to_string()



      [{result, get_score(result)} | agg]
    end)
    |> Enum.filter(fn {r, _} -> String.printable?(r, :infinity) end)
    |> Enum.sort_by(fn {_, s} -> s end, :desc)
    |> Enum.take(5)
    |> IO.inspect(label: IO.ANSI.format([:bright, :magenta, "\n-----\nTOP 5\n-----", :reset]), pretty: true)
    |> List.first()
    |> elem(0)
  end

  def get_score(str) do
    str
    |> String.upcase()
    |> String.to_charlist()
    |> Enum.reduce(0, fn char, agg ->
      if Enum.member?(~c(E T A O I N S H R D L U), char),
      do: agg + 1,
      else: agg
    end)
  end
  #~w"E T A O I N S H R D L U"
  #"ETAOINSHRDLU"
end

ExUnit.start()
ExUnit.configure(exclude: :pending, trace: true)

defmodule CryptoPals.Set1.Challenge3Test do
  @moduledoc """
  Tests for Cryptopals Challenge 1.
  For a submission to be considered "complete", all tests should pass.
  """

  @input_string "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"

  use ExUnit.Case
  alias CryptoPals.Set1.Challenge3

  describe "decrypt/1" do
    test "given a string, produces an integer" do
      assert "Cooking MC's like a pound of bacon" == Challenge3.decrypt(@input_string)
    end
  end
end
