defmodule CryptoPals.Set1.Challenge6 do
  @moduledoc """
  Source: 'https://cryptopals.com/sets/1/challenges/6'

  Solution code should be written here.

  To run tests, paste the following into the commandline from the project root.
  ```bash
  elixir -r cryptopals/set1/challenge6/elixir_template/challenge6_template.ex
  ```

  When submitting, change the name of this file to reflect the names of those that participated in the solution. (ex: `Challenge6_mary_linda_harriet.ex`)
  Then create a PR to add your file to the repo under `cryptopals/set1/challenge6/submitted_solutions/`.

  PROBLEM:
  Break repeating-key XOR
  It is officially on, now.

  This challenge isn't conceptually hard, but it involves actual error-prone coding. The other challenges in this set are there to bring you up to speed. This one is there to qualify you. If you can do this one, you're probably just fine up to Set 6.

  There's a file here: (./cryptopals/set1/challenge6/challenge_materials/6.txt). It's been base64'd after being encrypted with repeating-key XOR.

  Decrypt it.

  Here's how:

    1) Let KEYSIZE be the guessed length of the key; try values from 2 to (say) 40.

    2) Write a function to compute the edit distance/Hamming distance between two strings. The Hamming distance is just the number of differing bits. The distance between:

      `this is a test`

      and

      `wokka wokka!!!`

      is 37. Make sure your code agrees before you proceed.

    3) For each KEYSIZE, take the first KEYSIZE worth of bytes, and the second KEYSIZE worth of bytes, and find the edit distance between them. Normalize this result by dividing by KEYSIZE.

    4) The KEYSIZE with the smallest normalized edit distance is probably the key. You could proceed perhaps with the smallest 2-3 KEYSIZE values. Or take 4 KEYSIZE blocks instead of 2 and average the distances.

    5) Now that you probably know the KEYSIZE: break the ciphertext into blocks of KEYSIZE length.

    6) Now transpose the blocks: make a block that is the first byte of every block, and a block that is the second byte of every block, and so on.

    7) Solve each block as if it was single-character XOR. You already have code to do this.

    8) For each block, the single-byte XOR key that produces the best looking histogram is the repeating-key XOR key byte for that block. Put them together and you have the key.

  This code is going to turn out to be surprisingly useful later on. Breaking repeating-key XOR ("Vigenere") statistically is obviously an academic exercise, a "Crypto 101" thing. But more people "know how" to break it than can actually break it, and a similar technique breaks something much more important.

  ## No, that's not a mistake.

    We get more tech support questions for this challenge than any of the other ones. We promise, there aren't any blatant errors in this text. In particular: the "wokka wokka!!!" edit distance really is 37.
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

defmodule CryptoPals.Set1.Challenge6Test do
  @moduledoc """
  Tests for Cryptopals Challenge 1.
  For a submission to be considered "complete", all tests should pass.
  """

  use ExUnit.Case
  alias CryptoPals.Set1.Challenge6

  describe "example_fn/1" do
    test "given a string, produces an integer" do
      assert Challenge6.example_fn("1") == 1
    end
  end
end
