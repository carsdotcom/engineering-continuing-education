defmodule CryptoPals.Set1.Challenge1 do
  @moduledoc false

  @doc """
  Converts a base 8 to base 64

  """
  @spec hex_to_base64(String.t()) :: integer()
  def hex_to_base64(string) do
    string
    |> Base.decode16!(case: :lower)
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

  describe "hex_to_base64/1" do
    test "given a string, produces an integer" do
      assert Challenge1.hex_to_base64("49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d") == "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"
    end
  end
end
