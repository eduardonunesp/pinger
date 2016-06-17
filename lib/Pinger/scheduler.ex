defmodule Pinger.Scheduler do
  use GenServer

  alias Pinger.Cache
  alias Pinger.Target
  alias Pinger.Dispatcher
  alias Pinger.Report

  @doc """
  Starts the scheduler
  """
  def start_link do
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  @doc """
  Dispatch the request and wait for the report
  """
  def dispatch(server) do
    GenServer.call(server, {:dispatch})
  end

  def watch_loop(server) do
    GenServer.cast(server, {:watch_loop})
  end

  ## Callbacks

  def start_link(%Target{} = target) do
    GenServer.start_link(__MODULE__, target)
  end

  def init(target) do
    state = Cache.find(target.name) || %{name: target.name, target: target, report: nil}
    send(self(), :loop); 
    {:ok, state}
  end

  def handle_info(:loop, state) do
    if state.target.active do
      state = %{state | report: do_dispatch(state.target)}
      Cache.save(state)
      :timer.sleep state.target.interval
      send(self(), :loop); 
    end

    {:noreply, state}
  end

  def handle_call({:get}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:dispatch}, _from, state) do
    if state.target.active do
      state = %{state | report: do_dispatch(state.target)}
    end
    {:reply, state, state}
  end

  def handle_cast({:set, nstate}, state) do
    {:noreply, nstate, state}
  end

  def handle_cast({:watch_loop}, state) do
    send(self(), :loop);
    {:noreply, state, state}
  end

  defp do_dispatch(target) do
    case Dispatcher.dispatch(target) do
      {:ok, status_code} -> Report.new(target, status_code)
      {:error, _} -> Report.new(target, 500)
    end
  end
end