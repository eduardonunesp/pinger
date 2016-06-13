defmodule Pinger.Destiny do
  defstruct name: nil,
            address: nil,
            active: false

  def new(name, address, active \\ true) when is_binary(name) and is_binary(address) do
    %__MODULE__{
      name: name, 
      address: address,
      active: active
    }
  end

  def mark_inactive(%__MODULE__{} = dest) do
    %{ dest | active: false}
  end

  def mark_active(%__MODULE__{} = dest) do
    %{ dest | active: true}
  end

  def update_name(%__MODULE__{} = dest, name) when is_binary(name) do
    %{ dest | name: name}
  end

  def update_address(%__MODULE__{} = dest, address) when is_binary(address) do
    %{ dest | address: address}
  end
end