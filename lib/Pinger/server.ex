defmodule Pinger.Server do
  @moduledoc """
  Creates a supervisor server to manage schedulers
  """

  use Supervisor
  alias Pinger.Target

  @doc """
  Adds an schedulr to supervisor
  """
  def add_scheduler(%Target{} = target) do
    Supervisor.start_child(__MODULE__, [target])
  end

  @doc """
  Deletes an scheduler from supervisor
  """
  def delete_scheduler(scheduler) do
    Supervisor.terminate_child(__MODULE__, scheduler)
  end

  @doc """
  Returns all schedulers from supervisor
  """
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