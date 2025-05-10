number = round(2.345)
IO.puts("The number is #{number}")

list = [1, 2, 3, 4, true, false, "hello", :atom]
IO.inspect(list)

# Pattern matching
[a, b] = [1, 2]
IO.puts("a: #{a}, b: #{b}")

# Pattern matching with lists
# This will match the first four elements of the list and bind them to a, b, c, d
list = [1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6, "a", :b, true, :false]
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

defmodule Printer do
  # Recursive function to print elements
  # This function takes a list and prints each element then calls itself with the tail of the list
  def printElements([]), do: :finished # Base case: if the list is empty, return :finished
  def printElements([head | tail]) do
    IO.puts("Element: #{head}")
    printElements(tail)
  end
end

# Recursive function to print elements
Printer.printElements(list)

defmodule HundredDoors do
  # Function to simulate the 100 doors problem
  def doors(n) do
    # Create a list of doors, all initially closed (false)
    doors = for _ <- 1..n, do: false
    # Call the function to toggle the doors
    toggle_doors(doors, 1)
  end

  # Recursive function to toggle the doors
  # defp is a private function that is not accessible outside the module
  defp toggle_doors(doors, step) when step > length(doors), do: doors # Base case: if step is greater than the number of doors, return the doors list
  defp toggle_doors(doors, step) do
    # Toggle the doors that are multiples of the current step
    doors = doors
    |> Enum.with_index()
    |> Enum.map(fn {door, index} ->
      if rem(index + 1, step) == 0 do
        !door # Toggle the door (if it's closed, open it; if it's open, close it)
      else
        door # Leave the door as is
      end
    end)

    toggle_doors(doors, step + 1) # Recursive call with the next step
  end

end

# The return value of the doors function is piped to gain an index, then filtered to the doors that are open (true)
# The result is then mapped to get the door numbers (indexed+1)
output = HundredDoors.doors(100)
  |> Enum.with_index()
  |> Enum.filter(fn {door, _i} -> door == true end)
  |> Enum.map(fn {_door, i} -> i + 1 end)

# Print the open doors
IO.puts("Open doors: #{inspect(output)}")
