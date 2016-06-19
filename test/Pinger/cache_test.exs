defmodule Pinger.CacheTest do
  use ExUnit.Case

  alias Pinger.Cache
  alias Pinger.Target
  
  setup do
    target = Target.get_google

    state = %{name: target.name, target: target, report: nil}
    Cache.save(state)

    {:ok, target: target, state: state}
  end

  @tag :cache
  test "should save adds a list to the ETS table" do
    info = :ets.info(Cache)
    assert info[:size] == 1
  end

  @tag :cache
  test "should find gets a list out of the ETS table", %{target: target, state: state} do
    assert Cache.find(target.name) == state
  end

  @tag :cache
  test "should clear eliminates all objects from the ETS table", %{target: target} do
    Cache.clear
    refute Cache.find(target.name)
  end
end