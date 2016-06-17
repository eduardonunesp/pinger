defmodule Pinger.Target do
  defstruct name: nil,
            address: nil,
            interval: 10000,
            active: false

  @doc """
  Create a new Target struct with name, address, interval (default 10000) and active (default true)

  ## Example
      iex> Pinger.Target.new("Google", "https://www.google.com")
      %Pinger.Target{active: true, address: "https://www.google.com", interval: 10000, name: "Google"}

      iex> Pinger.Target.new("Google", "https://www.google.com", 5000, false)
      %Pinger.Target{active: false, address: "https://www.google.com", interval: 5000, name: "Google"}
  """
  def new(name, address, interval \\ 10000, active \\ true) when is_binary(name) and is_binary(address) do
    %__MODULE__{
      name: name, 
      address: address,
      interval: interval, 
      active: active
    }
  end

  @doc """
  Mark Target struct as inactive

  ## Example
      iex> dest = Pinger.Target.new("Google", "https://www.google.com")
      ...> Pinger.Target.mark_inactive(dest)
      %Pinger.Target{active: false, address: "https://www.google.com", name: "Google"}
  """
  def mark_inactive(%__MODULE__{} = dest) do
    %{ dest | active: false}
  end

  @doc """
  Mark Target struct as active

  ## Example
      iex> Pinger.Target.new("Google", "https://www.google.com", 10000, false)
      ...> |> Pinger.Target.mark_active
      %Pinger.Target{active: true, address: "https://www.google.com", interval: 10000, name: "Google"}
  """
  def mark_active(%__MODULE__{} = dest) do
    %{ dest | active: true}
  end

  @doc """
  Update Target struct name

  ## Example
      iex> Pinger.Target.new("Google", "https://www.google.com")
      ...> |> Pinger.Target.update_name("The Google")
      %Pinger.Target{active: true, address: "https://www.google.com", name: "The Google"}
  """
  def update_name(%__MODULE__{} = dest, name) when is_binary(name) do
    %{ dest | name: name}
  end

  @doc """
  Update Target struct address

  ## Example
      iex> Pinger.Target.new("Google", "https://www.google.com")
      ...> |> Pinger.Target.update_address("https://www.google.com.br")
      %Pinger.Target{active: true, address: "https://www.google.com.br", name: "Google"}
  """
  def update_address(%__MODULE__{} = dest, address) when is_binary(address) do
    %{ dest | address: address}
  end

  def get_google do
    new("Google", "https://www.google.com")
  end
end
