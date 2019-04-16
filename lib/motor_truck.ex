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
    |> Stream.each(fn(item) -> Store.set(store, item) end)
    |> Stream.run

    Store.get(store, "zymome")

    IO.puts(:os.system_time(:millisecond) - start)
  end

  def get_possibilities(number) do
    number
    |> String.split("", [ trim: true ])
    |> Enum.map(fn(num) ->
      case num do
        "2" -> ["a", "b", "c"]
        "3" -> ["d", "e", "f"]
        "4" -> ["g", "h", "i"]
        "5" -> ["j", "k", "l"]
        "6" -> ["m", "n", "o"]
        "7" -> ["p", "q", "r", "s"]
        "8" -> ["t", "u", "v"]
        "9" -> ["w", "x", "y", "z"]
      end
    end)
    |> Enum.reduce([[]], fn(current, acc) ->
      Enum.reduce(acc, [], fn(list, acc2) ->
        acc2 ++ Enum.map(current, fn(item) -> list ++ [item] end)
      end)
    end)
  end

  def run() do
    number = "6686787825"
    { :ok, store } = Store.start_link
    init_store(store)
    get_possibilities(number)
  end
end
