number = round(2.345)
IO.puts("The number is #{number}")

list = [1, 2, 3, 4, true, false, "hello", :atom]
IO.inspect(list)

# Pattern matching
[a, b] = [1, 2]
IO.puts("a: #{a}, b: #{b}")

# Pattern matching with lists
# This will match the first four elements of the list and bind them to a, b, c, d
list = [1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6]
[a, b, c | tail] = list
head = [a,b,c]
IO.puts("Head: #{inspect(head)}, Tail: #{inspect(tail)}")

# Case statement with pattern matching
case head do
  [1,2,3] ->
    IO.puts("Head matches [1,2,3]")
  [4,5,6] ->
    IO.puts("Head matches [4,5,6]")
  _ ->
    IO.puts("Head does not match [1,2,3]")
end

# if statement
if (a == 1) do
  IO.puts("a is 1")
else
  IO.puts("a is not 1")
end

# cond statement
cond do
  a + b == 2 ->
    IO.puts("a+b is 2")
  a + b == 3 ->
    IO.puts("a+b is 3")
  true ->
    IO.puts("a is neither 1 nor 2")
end

# Recursive function to print elements
# This function takes a list and prints each element then calls itself with the tail of the list
printElement = fn
  [] -> :finished # Base case: if the list is empty, return :finished
  [head | tail] ->
    IO.puts("Element: #{head}")
    printElement.(tail)
end

# Recursive function to print elements
printElement.(list)
