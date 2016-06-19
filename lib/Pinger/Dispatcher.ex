defmodule Pinger.Dispatcher do
  @moduledoc """
  Dispacher is responsible to dispatch http request and check if http target is valid
  """

  require Logger

  alias Pinger.Target

  @doc """
  Dispatch a http request

  ## Example
      iex> Pinger.Target.get_google
      ...> |> Pinger.Dispatcher.dispatch
      {:ok, 200}
  """
  def dispatch(%Target{} = target) do  
    Logger.debug "Requesting http #{target}"

    with {:ok, _          } <- check_address(target),
         {:ok, status_code} <- do_dispatch(target.address),
    do:  {:ok, status_code}
  end

  @doc """
  Check the http address to see if is a valid address

  ## Example
      iex> Pinger.Target.get_google |> Pinger.Dispatcher.check_address
      {:ok, true}
  """
  def check_address(%Target{} = target) do
    r = Regex.match?(~r/https?:\/\/.*/, target.address)
    cond do
      r == false -> {:error, "Invalid http address"}
      r == true  -> {:ok, r}
    end
  end

  # Do the dispatch using httpotion module
  defp do_dispatch(address) when is_binary(address) do
    r = HTTPotion.get(address, [follow_redirects: true])
    case r do
      %HTTPotion.Response{}      -> {:ok, r.status_code}
      %HTTPotion.ErrorResponse{} -> {:error, r.message}
      _ -> {:error, "Unknow error"}
    end
  end
end
