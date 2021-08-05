defmodule Decode do
  import Base
  use Bitwise, skip_operators: true

  def one(input) do
    input
    |> decode16!(case: :lower)
    |> encode64()
  end

  def two(input1, input2) do
    i1 = decode16!(input1, case: :lower)
    i2 = decode16!(input2, case: :lower)

    :binary.bin_to_list(i1)
    |> bxor_lists(:binary.bin_to_list(i2))
    # |> Enum.zip_reduce(:binary.bin_to_list(i2), [], fn one, two, acc ->
    #   [bxor(one, two) | acc]
    # end)
    # |> IO.inspect(label: "two zipped")
    |> Enum.reverse()
    |> to_string()
    # |> IO.inspect(label: "two reversed zipped")
    |> encode16(case: :lower)
  end

  defp bxor_lists(list1, list2) do
    Enum.zip_reduce(list1, list2, [], fn one, two, acc ->
      [bxor(one, two) | acc]
    end)
  end

  def three1(input1) do
    i1 = decode16!(input1, case: :mixed)

    i1bin = :binary.bin_to_list(i1)
    base_chars = 0..255

    Enum.map(base_chars, fn char ->
      Enum.map(i1bin, fn input_char ->
        bxor(input_char, char)
      end)
      # |> List.reverse()
      |> to_string()
      # |> IO.inspect(label: "sorted three")
      |> score(char)
    end)
    |> sort()
    |> List.first()
  end

  def three2(input1) do
    i1 = decode16!(input1, case: :mixed)

    i1bin = :binary.bin_to_list(i1)
    base_chars = 0..512

    Enum.map(base_chars, fn char ->
      i1bin
      |> Enum.reduce([], fn one, acc ->
        [bxor(one, char) | acc]
      end)
      |> Enum.reverse()
      |> to_string()
      |> score(char)
    end)
    |> sort()
    |> List.first()
  end

  def three3(input1, comparison_chars) do
    i1 = decode16!(input1, case: :mixed)

    i1bin = :binary.bin_to_list(i1)
    len = length(i1bin)
    Enum.map(comparison_chars, fn char ->
      # buffer_for = for _i <- 1..(len) do
      #   char
      # end
      buffer_dupe = List.duplicate(char, len)

      bxor_lists(i1bin, buffer_dupe)
      |> Enum.reverse()
      |> to_string()
      |> score(char)
    end)
    |> sort()
    |> List.first()
  end


  def four(data) do
    data
    |> Enum.map(fn input -> three2(input) end)
    |> sort()
    |> List.first()
  end

  def five(input, key) do
    i1bin = to_charlist(input)

    len = length(i1bin)
    ilen = String.length(input)

    (len == ilen) |> IO.inspect(label: "lengths?")

    index_bin = Enum.with_index(i1bin)
    # key_len = String.length(key)
    chars = to_charlist(key)

    buffer_for = for i <- 0..(len - 1) do
      Enum.at(chars, Integer.mod(i, 3))
    end
    |> IO.inspect(label: "buffer_for")

    xorred = bxor_lists(i1bin, buffer_for)

    x_str = xorred
    |> Enum.reverse()
    |> to_string()

    m_str = Enum.map(index_bin, fn {char, idx}  ->
      bxor(char, Enum.at(chars, Integer.mod(idx, 3)))
    end)
    |> to_string()
    |> encode16(case: :lower)
  end

  def distance(string1, string2) do
    bs1 = to_charlist(string1)
    bs2 = to_charlist(string2)

    Enum.zip_reduce(bs1, bs2, 0, fn one, two, acc ->
      xor = bxor(one, two)
      xor_digits = Integer.digits(xor, 2)
      xor_sum = Enum.sum(xor_digits)
      |> IO.inspect(label: "sum")
      acc + xor_sum
    end)
  end


    # distance/2 false-starts
    # length(bs1)  |> IO.inspect(label: "")
    # length(bs2)  |> IO.inspect(label: "")

    # l1 = Enum.flat_map(bs1, fn one ->
    #   Integer.digits(one, 2)
    #   |> IO.inspect(label: "")
    # end)
    # |> length
    # |> IO.inspect(label: "LENGTH1")
    # # |> IO.inspect(label: "list ONE")
    # l2 = Enum.flat_map(bs2, fn two ->
    #   Integer.digits(two, 2)
    #   |> IO.inspect(label: "")
    # end)
    # |> length
    # |> IO.inspect(label: "LENGTH2")
    # |> IO.inspect(label: "list TWO")

    # Enum.zip_reduce(l1, l2, 0, fn one, two, acc ->
    #   acc + if one == two do
    #     0
    #   else
    #     1
    #   end
    #   # |> IO.inspect(label: "curr accum")
    # end)
    # Enum.zip_reduce(bs1, bs2, 0, fn one, two, acc ->

      # l1 = Integer.digits(one, 2)
      # |> IO.inspect(label: "")
      # l2 = Integer.digits(two, 2)
      # |> IO.inspect(label: "")
      # len1 = length(l1)
      # |> IO.inspect(label: "LENGTH")
      # len2 = length(l2)
      # |> IO.inspect(label: "LENGTH")
      # len = if len1 > len2 do
      #   len1
      # else
      #   len2
      # end

      # Enum.reduce(0..(len-1), acc, fn i, inner_acc ->
      #   incr = if Enum.at(l1, i) == Enum.at(l2, i) do
      #     0
      #   else
      #     1
      #   end
      #   inner_acc + incr
      # end)
      # |> IO.inspect(label: "inner accum")
    # end)

    # Enum.reduce(bs1, {bs1, bs2, 0}, fn _, {l1, l2, a1} ->
    #   [h1 | t1] = l1
    #   # Integer.digits(h1), 2)
    #   # h1 |> IO.inspect(label: "h1")
    #   [h2 | t2] = l2
    #   # h2 |> IO.inspect(label: "h2")
    #   # diff = Integer.digits(h1, 2) - Integer.digits(h2, 2)

    #   a1 |> IO.inspect(label: "OUTER accumulator")
    #   a_diff = Enum.zip_reduce(Integer.digits(h1, 2), Integer.digits(h2, 2), a1, fn one, two, acc ->
    #     acc + if one == two do
    #       0
    #     else
    #       1
    #     end
    #     |> IO.inspect(label: "curr accum")

    #   end)
    #   # |> IO.inspect(label: "ADIFF")
    #   {t1, t2, a_diff}
    # end)
    # |> IO.inspect(label: "reduction")
    # Enum.reduce(bs1, fn _ ->

    # end)
    # (bs1 - bs2) |> IO.inspect(label: "diff")
    # Enum.zip_reduce(bs1, bs2, 0, fn one, two, acc ->
    #   bump =  if one == two do
    #     1
    #   else
    #     0
    #   end
    #   acc + bump
    # end)
    # |> IO.inspect(label: "")


  defp sort(list) do
    Enum.sort(list, fn {one, _, _}, {two, _, _} ->
      one >= two
    end)
  end

  defp score(string, char) do
    alphabet = "abcdefghijklmnopqrstuvwxyz "

    base_64_chars = String.codepoints(alphabet)

    pts = String.codepoints(String.downcase(string))
    score = Enum.count(pts, fn pt -> pt in base_64_chars end)
    {score, <<char::utf8>>, string}
  end
end

ExUnit.start()

defmodule DecodeTest do
  use ExUnit.Case

  test "one/1" do
    assert Decode.one(
             "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
           ) == "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"
  end

  test "two/2" do
    assert Decode.two(
             "1c0111001f010100061a024b53535009181c",
             "686974207468652062756c6c277320657965"
           ) == "746865206b696420646f6e277420706c6179"
  end

  test "three/1" do
    assert Decode.three1("1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736") ==
             {33, "X", "Cooking MC's like a pound of bacon"}
  end

  test "three-2" do
    assert Decode.three2("1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736") ==
             {33, "X", "Cooking MC's like a pound of bacon"}
  end

  test "three-3" do
    assert Decode.three3("1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736", 0..255) ==
             {33, "X", "Cooking MC's like a pound of bacon"}
  end

  test "four/1" do
    {:ok, contents} = File.read("cryptopals/set1/challenge1/data/4.txt")
    list = String.split(contents, "\n")

    assert Decode.four(list) == {29, "5", "Now that the party is jumping\n"}
  end

  test "five/2" do
    input = "Burning 'em, if you ain't quick and nimble
I go crazy when I hear a cymbal"
    # """
    key = "ICE"

    assert Decode.five(input, key) == "0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f"
  end

  test "distance/2" do
    one = "this is a test"
    two = "wokka wokka!!!"
    assert Decode.distance(one, two) == 37
  end

  # test "six/2" do
  #   {:ok, contents} = File.read("cryptopals/set1/challenge1/data/4.txt")
  #   list = String.split(contents, "\n")

  #   assert Decode.four(list) == {29, "5", "Now that the party is jumping\n"}

#     input = "Burning 'em, if you ain't quick and nimble
# I go crazy when I hear a cymbal"
#     # """
#     key = "ICE"

#     assert Decode.five(input, key) == "0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f"
  # end
end
