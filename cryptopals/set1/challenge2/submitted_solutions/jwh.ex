defmodule CryptoPals.Set1.Challenge2 do
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
  def example_fn(string1, string2) do
    list1 = string1
    |> to_decoded_charlist()
    |> IO.inspect(label: :list1)

    list2 = string2
    |> to_decoded_charlist()
    |> IO.inspect(label: :list2)

    list1
    |> Enum.with_index()
    |> Enum.map(fn {a, i} ->
      Bitwise.bxor(a, Enum.at(list2, i))
    end)
    |> IO.inspect(label: :results)
    |> to_string()
    |> Base.encode16(case: :lower)

  end

  defp to_decoded_charlist(string) do
    string
    |> Base.decode16!(case: :lower)
    |> to_charlist()
  end


end

ExUnit.start()
ExUnit.configure(exclude: :pending, trace: true)

defmodule CryptoPals.Set1.Challenge2Test do
  @moduledoc """
  Tests for Cryptopals Challenge 2.
  For a submission to be considered "complete", all tests should pass.
  """

  use ExUnit.Case
  alias CryptoPals.Set1.Challenge2

  describe "example_fn/1" do
    test "given a string, produces an integer" do
      input = "1c0111001f010100061a024b53535009181c"
      operand = "686974207468652062756c6c277320657965"
      result = "746865206b696420646f6e277420706c6179"
      assert Challenge2.example_fn(input, operand) == result
    end
  end
end
