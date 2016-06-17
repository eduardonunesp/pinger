defmodule Pinger.DispatcherTest do
  use ExUnit.Case
  alias Pinger.Dispatcher
  alias Pinger.Target
  alias Pinger.Server

  setup do
    target = Target.new("Google", "http://www.google.com")

    on_exit fn ->
      Enum.each Server.schedulers, fn(s) ->
        Server.delete_scheduler(s)
      end
    end

    {:ok, target: target}
  end

  describe "the dispatcher" do
    @tag :dispatcher
    test "should dispatch and return 200", %{target: target} do
      assert Dispatcher.dispatch(target) == {:ok, 200}, "Return must be {:ok, 200}"
    end

    @tag :dispatcher
    test "should not dispatch, because the invalid address", %{target: target} do
      target = Target.update_address(target, "http_invalid_address")
      assert Dispatcher.dispatch(target) == {:error, "Invalid http address"}, "Return must be {:error, \"Invalid http address\"}"
    end

    @tag :dispatcher
    test "should dispatch, but return nxdomain", %{target: target} do
      target = Target.update_address(target, "http://jucabaladasilvasaurojunior.com")
      assert Dispatcher.dispatch(target) == {:error, "nxdomain"}, "Return must be {:error, \"nxdomain\"}"
    end
  end
end