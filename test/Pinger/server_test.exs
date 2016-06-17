defmodule Pinger.ServerTest do
  use ExUnit.Case
  doctest Pinger.Server

  alias Pinger.Target
  alias Pinger.Server
  alias Pinger.Scheduler

  setup do
    target = Target.new("Google", "https://www.google.com")

    on_exit fn ->
      Enum.each Server.schedulers, fn(s) ->
        Server.delete_scheduler(s)
      end
    end

    {:ok, target: target}
  end

  describe "the server" do
    @describetag :server

    test "should adds new supervised scheduler", %{target: target} do
      Server.add_scheduler(target)
      count = Supervisor.count_children(Server)
      assert count.active == 1
    end

    test "should dispatch and return", %{target: target} do
      {:ok, scheduler} = Server.add_scheduler(target)
      result = Scheduler.dispatch scheduler
      assert result
    end
  end
end