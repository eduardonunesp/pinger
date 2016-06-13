defmodule Pinger.PingerTest do
  use ExUnit.Case, async: true

  alias Pinger.Destiny
  doctest Pinger.Destiny

  setup do
    destiny = Destiny.new("Google", "https://google.com")
    {:ok, destiny: destiny}
  end

  def assert_piped(value, key, expected, desc) do
    case Map.fetch(value, key) do
      {:ok, fetched} ->
        assert fetched == expected, desc
      {:error} ->
        raise "Key doesn't exists"
    end
  end

  describe "the destiny struct" do
    test "should create struct", %{destiny: destiny} do
      refute destiny == nil, "Destiny struct can't be nil"
    end

    test "should mark as inactive", %{destiny: destiny} do
      destiny 
        |> Destiny.mark_inactive
        |> assert_piped(:active, false, "Active must be false")
    end

    test "should mark as active", %{destiny: destiny} do
      destiny
        |> Destiny.mark_inactive
        |> Destiny.mark_active
        |> assert_piped(:active, true, "Active must be true")
    end

    test "should update the name", %{destiny: destiny} do
      destiny
        |> Destiny.update_name("NewName")
        |> assert_piped(:name, "NewName", "Name must be NewName")
    end

    test "should update the address", %{destiny: destiny} do
      destiny 
        |> Destiny.update_address("https://yahoo.com")
        |> assert_piped(:address, "https://yahoo.com", "Address must be https://yahoo.com")
    end
  end
end
