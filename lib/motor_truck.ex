defmodule MotorTruck do
  use Application
  alias MotorTruck.Store

  def start(_type, _args) do
    children = [Store]
    c = Supervisor.start_link(children, strategy: :one_for_one)
    start = :os.system_time(:millisecond)
    init_store()
    IO.puts("InitStore took #{:os.system_time(:millisecond) - start} ms")
    c
  end

  defp init_store() do
    File.stream!("dictionary.txt")
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.filter(fn (item) ->
      len = String.length(item)
      (len >= 3 && len < 8) || len == 10
    end)
    |> Stream.map(&String.downcase(&1))
    |> Stream.each(fn(item) ->
      Store.set(get_number(item), item)
    end)
    |> Stream.run
  end

  defp get_number(string) do
    string
    |> String.split("", [ trim: true ])
    |> Enum.map(fn(num) ->
      cond do
        num == "a" || num == "b" || num == "c" -> "2"
        num == "d" || num == "e" || num == "f" -> "3"
        num == "g" || num == "h" || num == "i" -> "4"
        num == "j" || num == "k" || num == "l" -> "5"
        num == "m" || num == "n" || num == "o" -> "6"
        num == "p" || num == "q" || num == "r" || num == "s" -> "7"
        num == "t" || num == "u" || num == "v" -> "8"
        num == "w" || num == "x" || num == "y" || num == "z" -> "9"
      end
    end)
    |> Enum.join
  end

  defp find(length, number, items) do
    item = String.slice(number, 0, length)

    case Store.get(item) do
      {:found, found} ->
        str_length = String.length(number)
        upto = str_length - length

        cond do
          upto > 3 ->
            3..(str_length - length)
            |> Enum.map(fn(i) ->
              found_new = find(i, String.slice(number, length, str_length), items)
              if(found_new != nil && Enum.all?(found_new, fn(item) -> item != nil end)) do
                items ++ [ found ] ++ found_new
              else
                nil
              end
            end)
          upto == 0 ->
            items ++ [ found ]
          true ->
            nil
        end
      {:not_found} ->
        nil
    end
  end

  defp get_combinations(items) do
    items
    |> Enum.reduce([[]], fn(current, acc) ->
      Enum.reduce(acc, [], fn(list, acc2) ->
        acc2 ++ Enum.map(current, fn(item) -> list ++ [item] end)
      end)
    end)
  end


  defp get_names(number) do
    outputs = 3..7
    |> Enum.map(fn(i) -> find(i, number, []) end)
    |> Enum.reduce([], fn(items, acc) ->
      if(items != nil) do
        acc ++ [ items |> Enum.filter(fn(i) -> i end) ]
      else
        acc
      end
    end)
    |> Enum.filter(fn(i) -> !Enum.empty?(i) end)
    |> Enum.map(fn([i]) -> get_combinations(i) end)


    case (Store.get(number)) do
      {:found, found} ->
        outputs ++ [ found ]
      {:not_found} ->
        outputs
    end
    |> Enum.concat()
  end

  def run(number) do
    if(String.length(number) == 10) do
      start = :os.system_time(:millisecond)
      output = get_names(number)
      IO.puts("Executed in #{:os.system_time(:millisecond) - start} ms")
      output
    else
      IO.puts("Please enter a valid number with 10 digits as a string")
    end
  end
end
