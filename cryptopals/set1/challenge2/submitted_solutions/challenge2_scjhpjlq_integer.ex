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
  @spec example_fn(String.t(), String.t()) :: String.t()
  def example_fn(op1, op2) do
    op1
    |> hex_string_to_int()
    |> Bitwise.bxor(hex_string_to_int(op2))
    |> Integer.to_string(16)
    |> String.downcase()
  end

  @spec hex_string_to_int(String.t()) :: integer()
  def hex_string_to_int(str), do: String.to_integer(str, 16)
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

  describe "example_fn/1" do
    # test "takes two equal-length buffers and produces their XOR combination" do
    # TODO: solve via binary representation to see the secret message
    # TODO: buffers, not strings?
    # TODO: handle arbitrary length (we're going to hit integer max at some point!)
    test "takes two strings and produces their XOR combination" do
      input = "1c0111001f010100061a024b53535009181c"
      operand = "686974207468652062756c6c277320657965"
      output = "746865206b696420646f6e277420706c6179"
      assert Challenge2.example_fn(input, operand) == output
    end
  end
end
