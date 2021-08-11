## XOR (Exclusive OR)

#### Notes and uses

But what does XOR do?!

XOR compares each of the bits (1 or 0) in a binary value (computer binary, not the Elixir/Erlang :binary type).

If the bits are the same, both 1 or 0, it returns 0, and if they're different, it returns 1.

#### XOR real examples

```elixir
Bitwise.bxor(99, 121)
26

Bitwise.bxor(121, 99)
26

Integer.digits(99, 2)
[1, 1, 0, 0, 0, 1, 1]

Integer.digits(121, 2)
[1, 1, 1, 1, 0, 0, 1]

Integer.digits(26, 2)
# leading 0s are dropped
[1, 1, 0, 1, 0]

[1, 1, 0, 0, 0, 1, 1] #99
[1, 1, 1, 1, 0, 0, 1] #121
[0, 0, 1, 1, 0, 1, 0] #26

Bitwise.bxor(77, 121)
52

Integer.digits(52, 2)
[1, 1, 0, 1, 0, 0]

Integer.digits(77, 2)
[1, 0, 0, 1, 1, 0, 1]
[1, 1, 1, 1, 0, 0, 1] #121
[0, 1, 1, 0, 1, 0, 0] #52
```

### XOR tricks

Refs:

- https://florian.github.io/xor-trick/
- https://hackernoon.com/xor-the-magical-bit-wise-operator-24d3012ed821


### In-Place Swapping

Swap two values x and y in-place, i.e. without using any helper variables.

```elixir
use Bitwise
x=1
y=2
x=bxor(x,y)
y=bxor(x,y)
x=bxor(x,y)
x #2
y #1
```

#### Find the duplicate number:

Given a list of N unique number where one of the numbers is duplicated, find the duplicate:

```elixir
length = 9999
list = for i <- 1..length, do: i
idx = :rand.uniform(length)
value = :rand.uniform(length)
list = List.insert_at(list, idx, value)
dupe = Enum.reduce(list, &(Bitwise.bxor(&1, &2)))
value == dupe # true
```

### Find the non-duplicate number:

The solution to this problem is the same as the previous problem.

For a given list of repeated elements, exactly one element is not repeated. You need to return the non-repeated element

```elixir
length = 9
list = for i <- 1..length, do: i
list = Enum.shuffle(list ++ list)
idx = :rand.uniform(length)
{value, list} = List.pop_at(list, idx)
nondupe = Enum.reduce(list, &(Bitwise.bxor(&1, &2)))
value == nondupe # true
```

### Find the missing number:

The solution to this problem is the same as the previous problem.

For a given unique elements, exactly one element is missing. You need to return the missing element

```elixir
length = 999
list = for i <- 1..length, do: i
idx = :rand.uniform(length)
{value, list} = List.pop_at(list, idx)
# order doesn't matter
list = Enum.shuffle(list)
missing = Enum.reduce(list, &(Bitwise.bxor(&1, &2)))
value == missing # true
```

#### Reverse the order

Given an unsorted ordered list (where the order does not change), reverse the order of the elements preserving the relative positioning.

For examle:
```elixir
l = [1, 3, 4, 2]
rev_l = Enum.reverse l
[2, 4, 3, 1]
```

If we don't want to use the `Enum.reverse/1` can we reverse the order with XOR?

We can!

There's an interesting property of XOR when you XOR a value against the next maximum bit value

```elixir
use Bitwise
1-2
bxor(0,1)
1
bxor(1,1)
0

Integer.digits(3, 2)
[1, 1]
1-4
bxor(0,3)
3
bxor(1,3)
2
bxor(2,3)
1
bxor(3,3)
0

Integer.digits(7, 2)
[1, 1, 1]
1-8
bxor(0,7)
7
bxor(1,7)
6
bxor(2,7)
5
bxor(3,7)
4
bxor(4,7)
3
bxor(5,7)
2
bxor(6,7)
1
bxor(7,7)
0
```

Each of the top-values in the range is all ones:

`Integer.digits(31, 2) => [1, 1, 1, 1, 1]`
`Integer.digits(255, 2) => [1, 1, 1, 1, 1, 1, 1, 1]`

This is a property of binary digits that you can use this top range to reverse an arbitray list preserving the order, if not the specific position at which the value is inserted.

Given the length value of 999
`Integer.digits(999, 2) => [1, 1, 1, 1, 1, 0, 0, 1, 1, 1]`
10 binary digits
`Integer.pow(2,10) = 1024`
`Integer.pow(2,10) = 1024 - 1 # to account for a 0-indexed list.`


```elixir
use Bitwise
length = 999
max_current_power_two =  Integer.pow(2,length(Integer.digits(length, 2))) - 1
list = for i <- 1..length, do: i
shuffled= Enum.shuffle list
new = List.duplicate(-1, length)
# account for 0-index and the difference between the max_current_power_two and the current index
diff = max_current_power_two - length + 1
{^length, reversed} = Enum.reduce(shuffled, {0, new}, fn x, {idx, l} = _acc ->

  new_index = bxor(max_current_power_two, idx) - diff
  {idx + 1, List.replace_at(l, new_index, x)}
end)
Enum.reverse(shuffled) == reversed # true
```
