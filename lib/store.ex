defmodule MotorTruck.Store do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def get(pid, item) do
    case GenServer.call(pid, {:get, item}) do
      [] -> {:not_found}
      [{result}] -> {:found, result}
    end
  end

  def set(pid, item) do
    GenServer.call(pid, {:set, item})
  end

  def handle_call({:get, item}, _from, state) do
    result = :ets.lookup(:test, item)
    {:reply, result, state}
  end

  def handle_call({:set, item }, _from, state) do
    true = :ets.insert(:test, {item})
    {:reply, item, state}
  end

  def init(:ok) do
    :ets.new(:test, [:set, :private, :named_table])
    { :ok, :ok }
  end
end
