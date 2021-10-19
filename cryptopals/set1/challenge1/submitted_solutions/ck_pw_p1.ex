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
    |> Enum.reverse()
    |> to_string()
    |> encode16(case: :lower)
  end

  defp bxor_lists(list1, list2) do
    Enum.zip_reduce(list1, list2, [], fn one, two, acc ->
      [bxor(one, two) | acc]
    end)
  end

  def three(input1, comparison_chars) do
    i1 = decode16!(input1, case: :mixed)

    i1bin = :binary.bin_to_list(i1)
    len = length(i1bin)
    Enum.map(comparison_chars, fn char ->
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
    |> Enum.map(fn input -> three(input, 0..255) end)
    |> sort()
    |> List.first()
  end

  def five_encode(input, key) do
    i1bin = to_charlist(input)
    len = length(i1bin)
    key_len = String.length(key)
    chars = to_charlist(key)

    buffer_for = for i <- 0..(len - 1) do
      Enum.at(chars, Integer.mod(i, key_len))
    end

    i1bin
    |> bxor_lists(buffer_for)
    |> Enum.reverse()
    |> to_string()
    |> encode16(case: :lower)
  end

  def five_decode(input, key) do
    i1bin = decode16!(input, case: :mixed)
    i1binlist = :binary.bin_to_list(i1bin)
    len = byte_size(i1bin)
    key_len = String.length(key)
    chars = to_charlist(key)

    buffer_for = for i <- 0..(len - 1) do
      Enum.at(chars, Integer.mod(i, key_len))
    end

    i1binlist
    |> bxor_lists(buffer_for)
    |> Enum.reverse()
    |> to_string()
  end

  def six(input) do
    maybe_keys = Decode.keysize(input)
    Enum.map(maybe_keys, fn {_, keysize} ->
      input
      |> Decode.transpose(keysize)
      |> Enum.map(fn tuple ->
        detect_xor_byte(tuple)
      end)
    end)
  end

  def detect_xor_byte(input) do
    base_chars = 0..255

    len = tuple_size(input)
    Enum.map(base_chars, fn char ->
      buffer_dupe = List.duplicate(char, len)
      list = Tuple.to_list(input)
      bxor_lists(list, buffer_dupe)
      |> Enum.reverse()
      |> to_string()
      |> score(char)
    end)
    |> sort()
    |> List.first()
  end

  def distance(string1, string2) do
    bs1 = to_charlist(string1)
    bs2 = to_charlist(string2)

    Enum.zip_reduce(bs1, bs2, 0, fn one, two, acc ->
      xor = bxor(one, two)
      xor_digits = Integer.digits(xor, 2)
      xor_sum = Enum.sum(xor_digits)
      acc + xor_sum
    end)
  end

  def keysize(input) do
    6..48
    |> Enum.map(fn i ->
      buf1 = String.slice(input, 0, i)
      buf2 = String.slice(input, i, i)
      buf3 = String.slice(input, (i * 2), i)
      buf4 = String.slice(input, (i * 3), i)
      buf5 = String.slice(input, (i * 4), i)
      buf6 = String.slice(input, (i * 5), i)

      dist1 = distance(buf1, buf2)
      dist2 = distance(buf2, buf3)
      dist3 = distance(buf3, buf4)
      dist4 = distance(buf4, buf5)
      dist5 = distance(buf5, buf6)

      avg_dist = (dist1 + dist2 + dist3 + dist4 + dist5) / (5 * i)

      {avg_dist, i}
    end)
    |> sort(&</2)
    |> Enum.take(6)
  end

  def transpose(input_string, keysize) do
    input_string
    |> :binary.bin_to_list()
    |> Enum.chunk_every(keysize)
    |> pad_last(keysize)
    |> Enum.zip()
  end

  defp pad_last(chunks, keysize) do
    last = List.last(chunks)
    list_len = length(last)

    if list_len < keysize do
      dupe = List.duplicate(0, (keysize - list_len))
      new_last = last ++ dupe
      List.replace_at(chunks, -1, new_last)
    else
      chunks
    end
  end

  def sort(list, sorter \\ &>=/2)
  def sort([{_, _} | _] = list, sorter) do
    Enum.sort(list, fn {one, _}, {two, _} ->
      sorter.(one, two)
    end)
  end

  def sort([{_, _, _} | _] = list, sorter) do
    Enum.sort(list, fn {one, _, _}, {two, _, _} ->
      sorter.(one, two)
    end)
  end

  def sort([{_, _, _, _} | _] = list, sorter) do
    Enum.sort(list, fn {one, _, _, _}, {two, _, _, _} ->
      sorter.(one, two)
    end)
  end

  defp score(string, char) when is_binary(string) do
    alphabet = "abcdefghijklmnopqrstuvwxyz "

    base_64_chars = String.codepoints(alphabet)

    pts = String.codepoints(String.downcase(string))
    score = Enum.count(pts, fn pt -> pt in base_64_chars end)
    # score = Enum.count(pts, fn pt -> pt in base_64_chars end)
    {score, <<char::utf8>>, char, string}
  end

  def eval(string, key) when is_binary(string) do
    alphabet = "abcdefghijklmnopqrstuvwxyz "

    base_64_chars = String.codepoints(alphabet)

    pts = String.codepoints(String.downcase(string))
    score = Enum.count(pts, fn pt -> pt in base_64_chars end)
    # score = Enum.count(pts, fn pt -> pt in base_64_chars end)
    {score, key, string}
  end
end

ExUnit.start()

defmodule DecodeTest do
  use ExUnit.Case

  # test "one/1" do
  #   assert Decode.one(
  #            "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
  #          ) == "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"
  # end

  # test "two/2" do
  #   assert Decode.two(
  #            "1c0111001f010100061a024b53535009181c",
  #            "686974207468652062756c6c277320657965"
  #          ) == "746865206b696420646f6e277420706c6179"
  # end

  # test "three" do
  #   assert Decode.three("1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736", 0..255) ==
  #            {33, "X", 88, "Cooking MC's like a pound of bacon"}
  # end

  # test "three-one" do
  #   string = "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"
  #   int = String.to_integer(string, 16)
  #   Bitwise.bxor(int, 97)
  #   # assert Decode.three("1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736", 0..255) ==
  #   #          {33, "X", 88, "Cooking MC's like a pound of bacon"}
  # end

  # test "four/1" do
  #   {:ok, contents} = File.read("cryptopals/set1/data/4.txt")
  #   list = String.split(contents, "\n")

  #   assert Decode.four(list) == {29, "5", 53, "Now that the party is jumping\n"}
  # end

  # test "five_encode/2" do
  #   input = "Burning 'em, if you ain't quick and nimble\nI go crazy when I hear a cymbal"
  #   # """
  #   key = "ICE"

  #   assert Decode.five_encode(input, key) == "0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f"
  # end

  # test "five_decode/2" do
  #   input = "0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f"
  #   output = "Burning 'em, if you ain't quick and nimble\nI go crazy when I hear a cymbal"
  #   # """
  #   key = "ICE"

  #   assert Decode.five_decode(input, key) == output
  # end

  # test "distance/2" do
  #   one = "this is a test"
  #   two = "wokka wokka!!!"
  #   assert Decode.distance(one, two) == 37
  # end

  # test "keysize/1" do
  #   {:ok, contents} = File.read("cryptopals/set1/data/6.txt")
  #   bin_contents = Base.decode64!(contents, ignore: :whitespace)
  #   [{_norm_dist, keysize} | _] = Decode.keysize(bin_contents)

  #   assert keysize == 29
  # end

  # test "transpose short strings into n" do
  #   contents  = "HUIfTQsPAh9PE048"
  #   keysize = 4
  #   transposed = Decode.transpose(contents, keysize)
  #   transposed_list = Enum.map(transposed, &(Tuple.to_list(&1)))
  #   assert transposed_list == ['HTAE', 'UQh0', 'Is94', 'fPP8']

  #   keysize = 8
  #   transposed = Decode.transpose(contents, keysize)
  #   transposed_list = Enum.map(transposed, &(Tuple.to_list(&1)))
  #   assert transposed_list == ['HA', 'Uh', 'I9', 'fP', 'TE', 'Q0', 's4', 'P8']

  #   keysize = 2
  #   transposed = Decode.transpose(contents, keysize)
  #   transposed_list = Enum.map(transposed, &(Tuple.to_list(&1)))
  #   assert transposed_list == ['HITsA9E4', 'UfQPhP08']
  # end

  # test "transpose a string into 4" do
  #   contents  = "HUIfTQsPAh9PE048GmllH0kcDk4TAQsHThsBFkU2AB4BSWQgVB0dQzNTTmVS"
  #   keysize = 4
  #   transposed = Decode.transpose(contents, keysize)
  #   transposed_list = Enum.map(transposed, &(Tuple.to_list(&1)))
  #   assert transposed_list == ['HTAEGHDATFASVQT', 'UQh0m0kQhkBWBzm', 'Is94lk4ssU4Q0NV', 'fPP8lcTHB2BgdTS']
  # end

  # test "transpose" do
  #   {:ok, contents} = File.read("cryptopals/set1/data/6.txt")
  #   keysize = 10
  #   transposed = Decode.transpose(contents, keysize)
  #   assert length(transposed) == keysize
  #   str_len = String.length(contents)
  #   first = List.first(transposed) |> Tuple.to_list()
  #   assert length(first) == (str_len / keysize) |> trunc()
  # end

  # test "six" do
  #   {:ok, contents} = File.read("cryptopals/set1/data/6.txt")
  #   bin_contents = Base.decode64!(contents, ignore: :whitespace)
  #   binary_encoded = bin_contents
  #   |> Base.encode16(case: :lower)

  #   key_candidates = Decode.six(bin_contents)
    # {_, key, decoded} = Enum.map(key_candidates, fn cand ->
    #   key = Enum.reduce(cand, "", fn {_, char, _, _}, acc -> acc <> char end)
    #   |> IO.inspect(label: "")
    #   decoded_str = Decode.five_decode(binary_encoded, key)
    #   |> IO.inspect(label: "")
    #   Decode.eval(decoded_str, key)
    #   |> IO.inspect(label: "")
    # end)
    # |> Decode.sort()
    # |> List.first

  #   assert key == "Terminator X: Bring the noise"
  #   last_n_chars = String.slice(decoded, -23, 23)
  #   assert last_n_chars == "Play that funky music \n"
  # end

  # MISC NOTES FOR 7
  # args = ["aes-128-ecb", "-in", path, "-K", Base.encode16(key), "-d", "-nopad"]

  # 59454C4C4F57205355424D4152494E45

  # openssl aes-128-ecb -in cryptopals/set1/data/7.txt -K key "YELLOW SUBMARINE" -d -nopad

  # :crypto.crypto_one_time(:aes_128_ecb, "YELLOW SUBMARINE", bin_contents, false)

  test "seven" do
    {:ok, contents} = File.read("cryptopals/set1/data/7.txt")
    # contents |> IO.inspect(label: "")
    bin_contents = Base.decode64!(contents, ignore: :whitespace)
    |> IO.inspect(label: "")
    binary_encoded = bin_contents
    |> Base.encode16(case: :lower)
    |> IO.inspect(label: "base16")


    key = "YELLOW SUBMARINE"
    # decoded_str = Decode.five_decode(binary_encoded, key)
    # |> IO.inspect(label: "decoded")
    # Decode.eval(decoded_str, key)
    # |> IO.inspect(label: "eval")
    # Decode.five_decode(binary_encoded, "YELLOW SUBMARINE")
    # key_candidates = Decode.six(bin_contents)
    # {_, key, decoded} = Enum.map(key_candidates, fn cand ->
    #   key = Enum.reduce(cand, "", fn {_, char, _, _}, acc -> acc <> char end)
    #   decoded_str = Decode.five_decode(binary_encoded, key)
    #   Decode.eval(decoded_str, key)
    # end)
    # |> Decode.sort()
    # |> List.first

    # assert key == "Terminator X: Bring the noise"
    # last_n_chars = String.slice(decoded, -23, 23)
    # assert last_n_chars == "Play that funky music \n"
  end
end
