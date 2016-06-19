defmodule Pinger.Utils do

  @doc """
  Remove Elixir.String.Char from module name

  ## Example
      iex> Elixir.String.Char.MyModule.Module
      ...> |> Pinger.Utils.mod_name
      "MyModule.Module"
  """
  def mod_name(module) do
    module |> Atom.to_string |> String.split(".") |> Enum.take(-2) |> Enum.join(".")
  end
end