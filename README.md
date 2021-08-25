# engineering-continuing-education
Language agnostic repository for Cars.com engineers to post solutions to code exercises

## Schedule
| Date  | Exercise | Elixir Template File Path  | Challenge URL  |  Notes |
|---|---|---|---|---|
|  7/14/21 @ 230pm CT|  Cryptopals, Set 1, Challenge 1 | [cryptopals/set1/challenge1/elixir_template/challenge1_template.ex](https://github.com/carsdotcom/engineering-continuing-education/blob/main/cryptopals/set1/challenge1/elixir_template/challenge1_template.ex)  | https://cryptopals.com/sets/1/challenges/1 |   |
|  7/21/21 @ 230pm CT| Cryptopals, Set 1, Challenge 2  | [cryptopals/set1/challenge2/elixir_template/challenge2_template.ex](https://github.com/carsdotcom/engineering-continuing-education/blob/main/cryptopals/set1/challenge2/elixir_template/challenge2_template.ex) | https://cryptopals.com/sets/1/challenges/2 |   |
|  7/28/21 @ 230pm CT| Cryptopals, Set 1, Challenge 3  | [cryptopals/set1/challenge3/elixir_template/challenge3_template.ex](https://github.com/carsdotcom/engineering-continuing-education/blob/main/cryptopals/set1/challenge3/elixir_template/challenge3_template.ex) | https://cryptopals.com/sets/1/challenges/3 |   |
|  8/04/21 @ 230pm CT| Cryptopals, Set 1, Challenge 3  | [cryptopals/set1/challenge3/elixir_template/challenge3_template.ex](https://github.com/carsdotcom/engineering-continuing-education/blob/main/cryptopals/set1/challenge3/elixir_template/challenge3_template.ex) | https://cryptopals.com/sets/1/challenges/3 |  Second round on this challenge. |
|  8/11/21 @ 230pm CT| Cryptopals, Set 1, Challenge 3  | [cryptopals/set1/challenge3/elixir_template/challenge3_template.ex](https://github.com/carsdotcom/engineering-continuing-education/blob/main/cryptopals/set1/challenge3/elixir_template/challenge3_template.ex) | https://cryptopals.com/sets/1/challenges/3 |  Third week of challenge 3, create string scorer |
|  8/18/21 @ 230pm CT| Cryptopals, Set 1, Challenge 4  | [cryptopals/set1/challenge4/elixir_template/challenge4_template.ex](https://github.com/carsdotcom/engineering-continuing-education/blob/main/cryptopals/set1/challenge4/elixir_template/challenge4_template.ex) | https://cryptopals.com/sets/1/challenges/4 | First week of new challenge |
|  8/25/21 @ 230pm CT| Cryptopals, Set 1, Challenge 4  | [cryptopals/set1/challenge4/elixir_template/challenge4_template.ex](https://github.com/carsdotcom/engineering-continuing-education/blob/main/cryptopals/set1/challenge4/elixir_template/challenge4_template.ex) | https://cryptopals.com/sets/1/challenges/4 | Second week of challenge 4|
|  9/01/21 @ 230pm CT| Cryptopals, Set 1, Challenge 5  | [cryptopals/set1/challenge5/elixir_template/challenge5_template.ex](https://github.com/carsdotcom/engineering-continuing-education/blob/main/cryptopals/set1/challenge5/elixir_template/challenge5_template.ex) | https://cryptopals.com/sets/1/challenges/5 | First week of challenge 5|
|   |   |   |   |   |

## Submitting Solutions

Navigate to the challenge, set, and problem folder for the problem you are solving.

Add a file named for your solution group. For example, if I am solving with Paully Walnuts, I might add a file named: ck_pw_p1.ex to the folder: cryptopals/set1/challenge1/submitted_solutions/

For ease of development, I will write my application code and test in the same file.

Example file:

```elixir
defmodule Decode do
  def hello, do: "world"
end

ExUnit.start()

defmodule DecodeTest do
  use ExUnit.Case

  test "hello/0" do
    assert Decode.hello() == "world"
  end
end

```

### Running Tests

`$ elixir -r cryptopals/set1/challenge1/submitted_solutions/ck_pw_p1.ex`

Ref: https://medium.com/@amuino/running-elixir-tests-without-a-mix-project-a97bc05a1657

