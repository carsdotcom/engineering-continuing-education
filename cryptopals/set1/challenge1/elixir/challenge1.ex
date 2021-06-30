defmodule CryptoPals.Set1.Challenge1 do
  @moduledoc """
  https://cryptopals.com/sets/1/challenges/1
  Solution code should be written here. Tests can be found at
  CryptoPals.Set1.Challenge1Test.
  """

  @doc """
  This is an example fn to serve the example test file. Please deleted it and write your own ;)
  """
  @spec example_fn(String.t()) :: integer()
  def example_fn(string) do
    String.to_integer(string)
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

  describe "example_fn/1" do
    test "given a string, produces an integer" do
      assert Challenge1.example_fn("1") == 1
    end
  end
end
