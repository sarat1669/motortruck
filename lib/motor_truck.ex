defmodule MotorTruck do
  alias MotorTruck.Store

  def init_store(store) do
    start = :os.system_time(:millisecond)

    File.stream!("dictionary.txt")
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.filter(fn (item) ->
      len = String.length(item)
      (len >= 3 && len < 8) || len == 10
    end)
    |> Stream.map(&String.downcase(&1))
    |> Stream.each(fn(item) ->
      Store.set(store, get_number(item), item)
    end)
    |> Stream.run

    # IO.inspect(Store.get(store, get_number("zyme")))

    # IO.puts(:os.system_time(:millisecond) - start)
  end

  def get_number(string) do
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

  def find(length, store, number, items) do
    item = String.slice(number, 0, length)

    case Store.get(store, item) do
      {:found, found} ->
        str_length = String.length(number)
        upto = str_length - length

        cond do
          upto > 3 ->
            3..(str_length - length)
            |> Enum.map(fn(i) ->
              found_new = find(i, store, String.slice(number, length, str_length), items)
              if(found_new != nil && Enum.all?(found_new, fn(item) -> item != nil end)) do
                items ++ [ found ++ found_new ]
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

  def get_names(store, number) do
    outputs = 3..6
    |> Enum.map(fn(i) -> find(i, store, number, []) end)
    |> Enum.reduce([], fn(items, acc) ->
      if(items != nil) do
        acc ++ [ items |> Enum.filter(fn(i) -> i end) ]
      else
        acc
      end
    end)
    |> Enum.filter(fn(i) -> !Enum.empty?(i) end)
    |> Enum.map(fn([i]) -> i end)


    case (Store.get(store, number)) do
      {:found, found} ->
        outputs ++ [ found ]
      {:not_found} ->
        outputs
    end
  end

  def run() do
    { :ok, store } = Store.start_link
    init_store(store)
    get_names(store, "6686787825")
    #get_names(store, "2282668687")
  end
end
