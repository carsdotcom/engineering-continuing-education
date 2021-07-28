defmodule CryptoPals.Set1.Challenge3 do
  use Bitwise
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
 @encrypted_message "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"
  @spec decrypt() :: integer()
  def decrypt do
    encrypted_int = decode_from_binary(@encrypted_message)
    decode_range = (0..255)
    Enum.map(decode_range, fn key ->
     encrypted_int
     |> bxor(key)
     |> Integer.to_string(16)
     |> Base.decode16!()
    end)
  end

   @spec decode_from_binary(String.t()) :: integer()
  defp decode_from_binary(string) do
    {int, _} = Integer.parse(string, 16)
    int
  end
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

  describe "example_fn/1" do
    test "given a string, produces an integer" do
      assert Challenge3.decrypt()
    end
  end
end
