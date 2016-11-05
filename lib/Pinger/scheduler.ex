defmodule Pinger.Scheduler do
  use GenServer
  require Logger

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
    GenServer.call(server, {:dispatch}, 60_000)
  end

  @doc """
  Get the current state
  """
  def get(server) do
    GenServer.call(server, {:get})
  end

  @doc """
  Start a watch loop to keep requesting the target at each target.interval
  """
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
      Process.send_after(self(), :loop, state.target.interval)
    end

    {:noreply, state}
  end

  def handle_call({:get}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:dispatch}, _from, state) do
    Logger.debug "Trying to ping #{state.target} ..."
    if state.target.active do
      Logger.debug "Pinging"
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
      {:ok, status_code} -> Report.new(target, status_code, "Remote access reached")
      {:error, "nxdomain"} -> Report.new(target, 0, "Can't reach the remote access")
      {:error, "req_timedout"} -> Report.new(target, 0, "Server not respond in 60 secs")
      {:error, message} -> Report.new(target, 0, message)
    end
  end
end