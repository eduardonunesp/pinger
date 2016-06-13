defmodule Pinger.DispatcherTest do
  use ExUnit.Case, async: true
  alias Pinger.Dispatcher
  alias Pinger.Destiny

  setup do
    destiny = Destiny.new("Google", "http://www.google.com")
    {:ok, destiny: destiny}
  end

  describe "the dispatcher" do
    test "should dispatch and return 200", %{destiny: destiny} do
      assert Dispatcher.dispatch(destiny) == {:ok, 200}
    end

    test "should not dispatch, because the invalid address", %{destiny: destiny} do
      destiny = Destiny.update_address(destiny, "http_invalid_address")
      assert Dispatcher.dispatch(destiny) == {:error, "Invalid http address"}
    end

    test "should dispatch, but return nxdomain", %{destiny: destiny} do
      destiny = Destiny.update_address(destiny, "http://jucabaladasilvasaurojunior.com")
      assert Dispatcher.dispatch(destiny) == {:error, "nxdomain"}
    end
  end
end