defmodule Pinger.PingerTest do
  use ExUnit.Case

  alias Pinger.Target
  doctest Pinger.Target

  setup do
    target = Target.new("Google", "https://google.com")
    {:ok, target: target}
  end

  def assert_piped(value, key, expected, desc) do
    case Map.fetch(value, key) do
      {:ok, fetched} ->
        assert fetched == expected, desc
      {:error} ->
        raise "Key doesn't exists"
    end
  end

  describe "the Target struct" do
    @tagdescribe :target
    test "should create struct", %{target: target} do
      refute target == nil, "Target struct can't be nil"
    end

    @tagdescribe :target
    test "should mark as inactive", %{target: target} do
      target 
        |> Target.mark_inactive
        |> assert_piped(:active, false, "Active must be false")
    end

    @tagdescribe :target
    test "should mark as active", %{target: target} do
      target
        |> Target.mark_inactive
        |> Target.mark_active
        |> assert_piped(:active, true, "Active must be true")
    end

    @tagdescribe :target
    test "should update the name", %{target: target} do
      target
        |> Target.update_name("NewName")
        |> assert_piped(:name, "NewName", "Name must be NewName")
    end

    @tagdescribe :target
    test "should update the address", %{target: target} do
      target 
        |> Target.update_address("https://yahoo.com")
        |> assert_piped(:address, "https://yahoo.com", "Address must be https://yahoo.com")
    end
  end
end
