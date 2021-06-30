Code.load_file("challenge1.ex", __DIR__)

ExUnit.start()
ExUnit.configure(exclude: :pending, trace: true)

defmodule CryptoPals.Set1.Challenge1Test do
  @moduledoc """
  Tests for Cryptopals Challenge 1.
  For a submission to be considered "complete", all tests should pass.
  """

  use ExUnit.Case

  describe "example_fn/1" do
    test "given a string, produces an integer" do
      assert example_fn("1") == 1
    end
  end
end
