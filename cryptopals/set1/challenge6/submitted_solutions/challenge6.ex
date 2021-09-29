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

  @file_path Path.expand(__DIR__) <> "/6.txt"
  @guessed_lengths 2..40

  def transpose([a | _] = list_of_lists) when is_list(list_of_list) and is_list(a) do
    list_of_lists
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  @spec to_list(tuple() | list()) :: list()
  defp to_list(tuple) when is_tuple(tuple), do: Tuple.to_list(tuple)
  defp to_list(list) when is_list(list), do: list

  @doc """
  Like Enum.zip/2 but concatenates the elements rather than pairing them in
  tuples. Useful if you want to append one or more elements to a list of lists
  in one pass.

  NB: the recursion and list concatenation seems like a poor performance choice,
  but that's literally how Erlang does it, so :shrug:.
  """
  @spec zip(tuple(), list(tuple() | list())) :: list(list())
  def zip(elems, accs) when is_tuple(elems) do
    zip(to_list(elems), accs)
  end

  def zip([elem_hd | elems], [acc_hd | accs]) do
    [to_list(acc_hd) ++ [elem_hd] | zip(elems, accs)]
  end

  @spec zip(list(), list(list()) | []) :: []
  def zip(_, []), do: []
  def zip([], _), do: []

  @doc """
  Like Enum.unzip/1, but unzips a list of tuples of arbitrary length, quitting
  when any tuple is exhausted. By the nature of its implementation, it also
  works for lists of lists.
      iex> CryptoPals.Set1.Challenge3.unzip([
      ...>   { 1 ,  2 ,  3 ,  4 },
      ...>   {"a", "b", "c", "d"},
      ...> ])
      [[1, "a"], [2, "b"], [3, "c"], [4, "d"]]
      iex> CryptoPals.Set1.Challenge3.unzip([
      ...>   { 1 ,  2 ,  3 ,  4 },
      ...>   {'A', 'B'          },
      ...>   {"a", "b", "c", "d"},
      ...> ])
      [[1, 'A', "a"], [2, 'B', "b"]]
  TODO: option to pad short tuples?
  TODO: option to output list of tuples?
  """
  @spec unzip(list(tuple() | list())) :: list(list())
  def unzip(tuples) do
    Enum.reduce(tuples, [], fn
      tuple, [] -> Enum.map(tuple, &[&1])
      tuple, acc -> zip(tuple, acc)
    end)
  end

  @doc """
  This is an example fn to serve the example test file. Please delete it and write your own ;)
  """
  @spec keymaster() :: String.t()
  def keymaster() do
    @file_path
    |> File.read!()
    |> String.replace("\n", "")
    |> loopy_chunks()
  end

  # @spec hamming_distance(String.t(), String.t())
  def hamming_distance(a, b) when is_binary(a) do
    hamming_distance(to_charlist(a), to_charlist(b))
  end

  # @spec hamming_distance(charlist(), charlist())
  def hamming_distance(a, b) when is_list(a) do
    [a, b]
    |> Enum.zip()
    |> Enum.reduce(0, fn {a, b}, agg ->
      a
      |> Bitwise.bxor(b)
      |> Integer.to_string(2)
      |> to_charlist()
      |> Enum.count(fn
        ?0 -> false
        ?1 -> true
      end)
      |> Kernel.+(agg)
    end)
  end

  @spec loopy_chunks(String.t()) :: [String.t()]
  defp loopy_chunks(encoded_string) do
    @guessed_lengths
    |> Enum.map(fn keysize ->
      # take the first KEYSIZE worth of bytes, and the second KEYSIZE worth of bytes,
      [first_chunk, second_chunk] =
        encoded_string
        |> to_charlist()
        |> Enum.chunk_every(keysize)
        |> Enum.take(2)

      # find the edit distance between them.
      # Normalize this result by dividing by KEYSIZE.
      score = hamming_distance(first_chunk, second_chunk) / keysize

      {keysize, score}
    end)
    # Find keysize smallest normalized edit distance
    |> Enum.sort_by(fn {_keysize, score} -> score end, :asc)
    |> Enum.take(10)
    |> IO.inspect()

    # |> Chunk by KEYSIZE.
    # |> Transpose
    # For each chunk
    # |> Determine single character XOR (with histogram)
    # end
    # |> Combine single characters into key?
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

  describe("transpose/1") do
    test "given a list of lists transposes" do
      assert [
               [1, "a", :x],
               [2, "b", :y],
               [3, "c", :z]
             ] ==
               Challenge6.transpose([
                 [1, 2, 3],
                 ["a", "b", "c"],
                 [:x, :y, :z]
               ])
    end
  end

  describe "keymaster/0" do
    test "with a valid text file, returns something" do
      Challenge6.keymaster()
    end
  end

  describe "hamming_distance" do
    test "computes the edit distance given two strings" do
      assert 37 == Challenge6.hamming_distance("this is a test", "wokka wokka!!!")
      assert 1 == Challenge6.hamming_distance("A", "@")
    end
  end
end
