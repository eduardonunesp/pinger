defmodule Pinger.Dispatcher do
  alias Pinger.Destiny

  def dispatch(%Destiny{} = dest) do  
    with {:ok, _          } <- check_address(dest),
         {:ok, status_code} <- do_dispatch(dest.address),
    do:  {:ok, status_code}
  end

  def check_address(%Destiny{} = dest) do
    r = Regex.match?(~r/https?:\/\/.*/, dest.address)
    cond do
      r == false -> {:error, "Invalid http address"}
      r == true  -> {:ok, r}
    end
  end

  defp do_dispatch(address) when is_binary(address) do
    r = HTTPotion.get(address, [follow_redirects: true])
    case r do
      %HTTPotion.Response{}      -> {:ok, r.status_code}
      %HTTPotion.ErrorResponse{} -> {:error, r.message}
      _ -> {:error, "Unknow error"}
    end
  end
end