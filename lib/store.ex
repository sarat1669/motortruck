defmodule MotorTruck.Store do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, [ name: __MODULE__ ])
  end

  def get(item) do
    case GenServer.call(__MODULE__, {:get, item}) do
      [] -> {:not_found}
      [{_number, names}] -> {:found, names}
    end
  end

  def set(item, value) do
    GenServer.call(__MODULE__, {:set, item, value})
  end

  def handle_call({:get, item}, _from, state) do
    result = :ets.lookup(:test, item)
    {:reply, result, state}
  end

  def handle_call({:set, item, value }, _from, state) do
    value = case :ets.lookup(:test, item) do
      [] -> [ value ]
      [{ _number, values }] -> values ++ [ value ]
    end

    true = :ets.insert(:test, {item, value})
    {:reply, item, state}
  end

  def init(:ok) do
    :ets.new(:test, [:set, :private, :named_table])
    { :ok, :ok }
  end
end
