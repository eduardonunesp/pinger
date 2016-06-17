defmodule Pinger.SchedulerTest do
  use ExUnit.Case
  alias Pinger.Scheduler
  alias Pinger.Target
  alias Pinger.Server
  doctest Pinger.Scheduler

  setup do
    target = Target.new("Google", "https://www.google.com")
    {:ok, scheduler} = Server.add_scheduler(target)

    on_exit fn ->
      Enum.each Server.schedulers, fn(s) ->
        Server.delete_scheduler(s)
      end
    end

    {:ok, scheduler: scheduler}
  end
 
  describe "the scheduler" do
    @describtag :scheduler
    test "schedule and dispatch", %{scheduler: scheduler} do
      result = Scheduler.dispatch(scheduler)
      assert result.report.status_code == 200
    end
  end
end