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
    |> Stream.map(&get_number/1)
    |> Stream.each(fn(item) -> Store.set(store, item) end)
    |> Stream.run

    IO.inspect(Store.get(store, get_number("zyme")))

    IO.puts(:os.system_time(:millisecond) - start)
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

  def run() do
    { :ok, store } = Store.start_link
    init_store(store)
    get_number("helloworld")
  end
end
