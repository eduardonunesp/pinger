defmodule Pinger do
  @moduledoc """
  Pinger is an application to help you to monitoring your HTTP endpoints, like a health check. Pinger creates and supervises HTTP requests, also Pinger checks targets URLs on an configured interval. We call targets, you can add many targets as you wish to keep checking and acting when needed.
  """

  use Application

  alias Pinger.Target
  alias Pinger.Server
  alias Pinger.Cache

  def watch_target(%Target{} = target) do
    Server.add_scheduler(target)
  end

  def unwatch_target(scheduler) do
    Server.delete_scheduler(scheduler)
  end

  def target_state(%Target{} = target) do
    Cache.find(target.name)
  end

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      # worker(Todo.Worker, [arg1, arg2, arg3]),
      worker(Pinger.Cache, []),
      supervisor(Pinger.Server, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pinger.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
