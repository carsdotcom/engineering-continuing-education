defmodule CryptoPals.Set1.Challenge1 do
  @moduledoc """
  Source: 'https://cryptopals.com/sets/1/challenges/1'

  """

  @doc """
  Decodes hex and re-encodes as Base64
  """
  @spec hex_to_base64(String.t()) :: String.t()
  def hex_to_base64(string) do
    string
    |> Base.decode16(case: :lower)
    |> encode_base64()
  end

  defp encode_base64({:ok, binary}), do: Base.encode64(binary)
  defp encode_base64(error), do: error
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
    test "given a hex decodes binary and encodes as base64" do
      hex = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
      expect_result = "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"
      assert Challenge1.hex_to_base64(hex) == expect_result
    end

    test "returns an error with invalid hex" do
      hex = "pizzaisnothex"
      assert Challenge1.hex_to_base64(hex) == :error
    end
  end
end
