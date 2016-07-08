defmodule Pinger.DispatcherTest do
  use ExUnit.Case
  alias Pinger.Dispatcher
  alias Pinger.Target
  alias Pinger.Server
  doctest Pinger.Dispatcher

  setup do
    target = Target.new("Google", "http://www.google.com")

    on_exit fn ->
      Enum.each Server.schedulers, fn(s) ->
        Server.delete_scheduler(s)
      end
    end

    {:ok, target: target}
  end

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

  @tag :dispatcher
  test "should dispatch, but return 404" do
    target = Target.new("Httpbin", "http://httpbin.org/status/404")
    assert Dispatcher.dispatch(target) == {:ok, 404}
  end

  @tag :dispatcher
  test "should dispatch, but return 201" do
    target = Target.new("Httpbin", "http://httpbin.org/status/201")
    assert Dispatcher.dispatch(target) == {:ok, 201}
  end

  @tag :dispatcher
  test "should dispatch, but return 500" do
    target = Target.new("Httpbin", "http://httpbin.org/status/500")
    assert Dispatcher.dispatch(target) == {:ok, 500}
  end

  # test "should dispatch an post request"
  # test "should dispatch an put request "
  # test "should dippatch an delete request"
end