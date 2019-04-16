defmodule MotorTruck do
  alias MotorTruck.Store

  def run do
    {:ok, store} = Store.start_link

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
end
