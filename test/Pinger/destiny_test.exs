defmodule Pinger.PingerTest do
  use ExUnit.Case, async: true
  alias Pinger.Destiny

  setup do
    destiny = Destiny.new("Google", "https://google.com")
    {:ok, destiny: destiny}
  end

  describe "the destiny struct" do
    test "should create struct", %{destiny: destiny} do
      assert destiny != nil
    end

    test "should mark as inactive", %{destiny: destiny} do
      destiny = destiny |> Destiny.mark_inactive
      assert destiny.active == false
    end

    test "should mark as active", %{destiny: destiny} do
      destiny = destiny 
        |> Destiny.mark_inactive
        |> Destiny.mark_active
      assert destiny.active == true
    end

    test "should update the name", %{destiny: destiny} do
      destiny = destiny |> Destiny.update_name("NewName")
      assert destiny.name == "NewName"
    end

    test "should update the address", %{destiny: destiny} do
      destiny = destiny |> Destiny.update_address("https//yahoo.com")
      assert destiny.address == "https//yahoo.com"
    end
  end
end
