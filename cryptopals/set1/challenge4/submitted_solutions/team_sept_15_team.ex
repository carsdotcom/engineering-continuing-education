defmodule CryptoPals.Set1.Challenge4 do
  @moduledoc """
  Source: 'https://cryptopals.com/sets/1/challenges/4'

  Solution code should be written here.

  To run tests, paste the following into the commandline from the project root.
  ```bash
  elixir -r cryptopals/set1/challenge4/elixir_template/challenge4_template.ex
  ```

  When submitting, change the name of this file to reflect the names of those that participated in the solution. (ex: `Challenge4_mary_linda_harriet.ex`)
  Then create a PR to add your file to the repo under `cryptopals/set1/Challenge4/submitted_solutions/`.

  PROBLEM:
  Detect single-character XOR
  One of the 60-character strings in this file (cryptopals/set1/challenge4/challenge_materials/challenge4.txt) has been encrypted by single-character XOR.

  Find it.

  (Your code from challenge #3 should help.)
  """

  @doc """
  This is an example fn to serve the example test file. Please delete it and write your own ;)
  """

  def read_file do
    "./cryptopals/set1/challenge4/submitted_solutions/challenge4.txt"
    |> File.read!()
    |> String.split("\n")
  end

  def example_fn do
    all_keys()
    |> Enum.flat_map(fn key ->
      Enum.map(read_file(), fn phrase ->
        decrypt_string(phrase, key)
      end)
    end)
    |> reject_unprintable()
    |> contains_spaces()
    |> tuple_w_frequencies()
    |> Enum.sort_by(
      fn {string, freq} ->
        space = get_max_of(freq, ?\s, 5)
        a = get_max_of(freq, ?a, 5) + get_max_of(freq, ?A, 5)
        e = get_max_of(freq, ?e, 5) + get_max_of(freq, ?E, 5)
        i = get_max_of(freq, ?i, 5) + get_max_of(freq, ?I, 5)
        o = get_max_of(freq, ?o, 5) + get_max_of(freq, ?O, 5)
        u = get_max_of(freq, ?u, 5) + get_max_of(freq, ?U, 5)

        sort_value = space + a + e + i + o + u

        if sort_value > 4 do
          IO.inspect(string)
        end

        sort_value
      end,
      :desc
    )
    |> Enum.take(1)
  end

  def get_max_of(map, key, max) do
    value = Map.get(map, key, 0)

    if value > max do
      5
    else
      value
    end
  end

  def tuple_w_frequencies(strings) do
    Enum.map(strings, fn string ->
      {string, Enum.frequencies(string)}
    end)
  end

  def reject_unprintable(strings) do
    Enum.filter(strings, fn string ->
      string
      |> Enum.join("")
      |> String.printable?()
    end)
  end

  def contains_spaces(strings) do
    Enum.filter(strings, &Enum.member?(&1, ?\s))
  end

  def decrypt_string(string, key) do
    phrase_as_list =
      string
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer(&1, 16))

    Enum.map(phrase_as_list, fn character ->
      Bitwise.bxor(character, key)
    end)
  end

  def all_keys do
    32..126
  end
end

ExUnit.start()
ExUnit.configure(exclude: :pending, trace: true)

defmodule CryptoPals.Set1.Challenge4Test do
  @moduledoc """
  Tests for Cryptopals Challenge 1.
  For a submission to be considered "complete", all tests should pass.
  """

  use ExUnit.Case
  alias CryptoPals.Set1.Challenge4

  describe "example_fn/1" do
    test "given a string, produces an integer" do
      IO.inspect(Challenge4.example_fn())
      # assert Challenge4.example_fn("1") == 1
    end
  end
end
