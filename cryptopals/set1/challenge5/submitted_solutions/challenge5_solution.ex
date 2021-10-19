defmodule CryptoPals.Set1.Challenge5 do
  @moduledoc """
  Source: 'https://cryptopals.com/sets/1/challenges/5'

  Solution code should be written here.

  To run tests, paste the following into the commandline from the project root.
  ```bash
  elixir -r cryptopals/set1/challenge5/elixir_template/challenge5_template.ex
  ```

  When submitting, change the name of this file to reflect the names of those that participated in the solution. (ex: `Challenge5_mary_linda_harriet.ex`)
  Then create a PR to add your file to the repo under `cryptopals/set1/Challenge5/submitted_solutions/`.

  PROBLEM:
  Implement repeating-key XOR

  Here is the opening stanza of an important work of the English language:

  ```bash
  Burning 'em, if you ain't quick and nimble
  I go crazy when I hear a cymbal
  ```

  Encrypt it, under the key "ICE", using repeating-key XOR.

  In repeating-key XOR, you'll sequentially apply each byte of the key; the first byte of plaintext will be XOR'd against I, the next C, the next E, then I again for the 4th byte, and so on.

  It should come out to:

  ```bash
  0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272
  a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f
  ```

  Encrypt a bunch of stuff using your repeating-key XOR function. Encrypt your mail. Encrypt your password file. Your .sig file. Get a feel for it. I promise, we aren't wasting your time with this.
  """

  @spec en_ice(String.t()) :: String.t()
  def en_ice(strings) when is_binary(strings) do
    # > In repeating-key XOR, you'll sequentially apply each byte of the key;
    # > the first byte of plaintext will be XOR'd against I, the next C, the next E,
    # > then I again for the 4th byte, and so on.

    # Get bytes from string
    # Get ICE whatever we decide
    # - Cycle: https://hexdocs.pm/elixir/1.12/Stream.html#cycle/1
    # Iterate through bytes and take appropriate ICE byte

    icycle = Stream.cycle([?I, ?C, ?E])

    strings
    |> String.trim()
    |> encoder(icycle)
  end

  defp encoder(line, icycle) do
    line
    |> to_charlist()
    |> Enum.zip(icycle)
    |> Enum.map(fn {char, ice_char} ->
      Bitwise.bxor(char, ice_char)
    end)
    |> List.to_string()
    |> Base.encode16(case: :lower)
  end
end

ExUnit.start()
ExUnit.configure(exclude: :pending, trace: true)

defmodule CryptoPals.Set1.Challenge5Test do
  @moduledoc """
  Tests for Cryptopals Challenge 1.
  For a submission to be considered "complete", all tests should pass.
  """

  use ExUnit.Case
  alias CryptoPals.Set1.Challenge5

  @input_string """
  Burning 'em, if you ain't quick and nimble
  I go crazy when I hear a cymbal
  """

  @output_string "0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f"

  describe "example_fn/1" do
    test "given a plaintext lyric, XORs by 'ICE', repeatedly" do
      assert Challenge5.en_ice(@input_string) == @output_string
    end
  end
end
