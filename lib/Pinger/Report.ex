defmodule Pinger.Report do
  alias Pinger.Destiny

  defstruct destiny: nil,
            result: 404

  def new(%Destiny{} = dest, result) when is_integer(result) do
    %__MODULE__{
      destiny: dest,
      result: result
    }
  end

  def update_result(%__MODULE__{} = report, result) when is_integer(result) do
    %{ report | result: result}
  end
end