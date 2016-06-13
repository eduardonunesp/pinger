defmodule Pinger.Destiny do
  defstruct name: nil,
            address: nil,
            active: false

  @doc """
    Create a new Destiny struct with name, address and active (default true)

    ## Example

    iex> Pinger.Destiny.new("Google", "https://www.google.com")
    %Pinger.Destiny{active: true, address: "https://www.google.com", name: "Google"}

    iex> Pinger.Destiny.new("Google", "https://www.google.com", false)
    %Pinger.Destiny{active: false, address: "https://www.google.com", name: "Google"}

  """
  def new(name, address, active \\ true) when is_binary(name) and is_binary(address) do
    %__MODULE__{
      name: name, 
      address: address,
      active: active
    }
  end

  @doc """
    Mark Destiny struct as inactive

    ## Example

    iex> dest = Pinger.Destiny.new("Google", "https://www.google.com")
    ...> Pinger.Destiny.mark_inactive(dest)
    %Pinger.Destiny{active: false, address: "https://www.google.com", name: "Google"}

  """
  def mark_inactive(%__MODULE__{} = dest) do
    %{ dest | active: false}
  end

  @doc """
    Mark Destiny struct as active

    ## Example

    iex> Pinger.Destiny.new("Google", "https://www.google.com")
    ...> |> Pinger.Destiny.mark_inactive
    ...> |> Pinger.Destiny.mark_active
    %Pinger.Destiny{active: true, address: "https://www.google.com", name: "Google"}

  """
  def mark_active(%__MODULE__{} = dest) do
    %{ dest | active: true}
  end

  @doc """
    Update Destiny struct name

    ## Example

    iex> Pinger.Destiny.new("Google", "https://www.google.com")
    ...> |> Pinger.Destiny.update_name("The Google")
    %Pinger.Destiny{active: true, address: "https://www.google.com", name: "The Google"}

  """
  def update_name(%__MODULE__{} = dest, name) when is_binary(name) do
    %{ dest | name: name}
  end

  @doc """
    Update Destiny struct address

    ## Example

    iex> Pinger.Destiny.new("Google", "https://www.google.com")
    ...> |> Pinger.Destiny.update_address("https://www.google.com.br")
    %Pinger.Destiny{active: true, address: "https://www.google.com.br", name: "Google"}

  """
  def update_address(%__MODULE__{} = dest, address) when is_binary(address) do
    %{ dest | address: address}
  end
end