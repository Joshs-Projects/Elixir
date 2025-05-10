# To run this file in the terminal, use the command:
# elixir 100doors.ex and make sure you are in the same directory as the file

# Define the number of doors
doors = 10000

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

#IO.puts("Sleeping for 120 seconds to allow the cores to cool down")
#:timer.sleep(120000) # Sleep for 120 second to allow the cores to cool down
#IO.puts("Waking up now")

# The return value of the doors function is piped to gain an index, then filtered to the doors that are open (true)
# The result is then mapped to get the door numbers (indexed+1)

# Lets time it now so that we can compare the performance of the two implementations
{time_microseconds, result} = :timer.tc(fn ->
  HundredDoors.doors(doors)
    |> Enum.with_index()
    |> Enum.filter(fn {door, _i} -> door == true end)
    |> Enum.map(fn {_door, i} -> i + 1 end)
  end)

# Print the open doors
IO.puts("Open doors: #{inspect(result)} and took #{time_microseconds/1_000_000} seconds")

#IO.puts("Sleeping for 120 seconds to allow the cores to cool down")
#:timer.sleep(120000) # Sleep for 120 second to allow the cores to cool down
#IO.puts("Waking up now")

defmodule HundredDoorsParallel do
  def doors(n) do
    # All doors start closed (false)
    doors = for _ <- 1..n, do: false

    # Use Task.async_stream to parallelize steps 1..n
    1..n
    |> Task.async_stream(fn step -> toggled_indices(step, n) end, max_concurrency: System.schedulers_online()) # Parallelize the toggling of doors
    |> Enum.map(fn {:ok, indices} -> indices end) # Collect the results
    |> List.flatten() # Flatten the list of lists into a single list
    |> Enum.frequencies() # Count the number of times each door was toggled
    |> Enum.reduce(doors, fn {index, count}, doors ->
      # Toggle the door if it was toggled an odd number of times
      List.update_at(doors, index, fn val -> rem(count, 2) == 1 and !val or val end) # Update doors at index and if val is odd, toggle it
    end)
  end

  # For a given step, return the indices of doors that are toggled
  defp toggled_indices(step, max) do
    Enum.filter(0..(max - 1), fn i -> rem(i+1, step) == 0 end) # Return the indices of doors that are toggled
  end
end

# Lets time it now so that we can compare the performance of the two implementations
{time_microseconds, result} = :timer.tc(fn ->
  HundredDoorsParallel.doors(doors)
    |> Enum.with_index() # Add index to each door
    |> Enum.filter(fn {door, _i} -> door == true end) # Filter to get only the open doors
    |> Enum.map(fn {_door, i} -> i + 1 end) # Map to get the door numbers (indexed+1)
end)
IO.puts("Open doors: #{inspect(result)} and took #{time_microseconds/1_000_000} seconds using #{System.schedulers_online()} schedulers")
