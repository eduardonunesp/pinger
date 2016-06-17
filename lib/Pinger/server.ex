defmodule Pinger.Server do
  use Supervisor
  alias Pinger.Target

  def add_scheduler(%Target{} = target) do
    Supervisor.start_child(__MODULE__, [target])
  end

  def delete_scheduler(scheduler) do
    Supervisor.terminate_child(__MODULE__, scheduler)
  end

  def schedulers do
    __MODULE__
    |> Supervisor.which_children
    |> Enum.map(fn({_, child, _, _}) -> child end)
  end

  ## Callbacks

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    children = [
      worker(Pinger.Scheduler, [], restart: :transient)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end