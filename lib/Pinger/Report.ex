defmodule Pinger.Report do
  alias Pinger.Target

  defstruct target: nil,
            status_code: 404

  def new(%Target{} = target, status_code) when is_integer(status_code) do
    %__MODULE__{
      target: target,
      status_code: status_code
    }
  end

  def update_status_code(%__MODULE__{} = report, status_code) when is_integer(status_code) do
    %{ report | status_code: status_code}
  end
end