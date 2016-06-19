defmodule Pinger.Report do
  @moduledoc """
  Result of each request to test, contains the target, status code and error description if does
  """

  require Logger

  alias Pinger.Target

  defstruct target: nil,
            status_code: 404,
            cause: nil


  defimpl String.Chars, for: __MODULE__ do
    def to_string(report) do
      "%#{Pinger.Utils.mod_name(__MODULE__)}{target: #{report.target}, status_code: #{report.status_code}, cause: #{report.cause}}"
    end
  end            

  @doc """
  ## Example
      iex> Pinger.Target.get_google
      ...> |> Pinger.Report.new(200)
      %Pinger.Report{cause: nil, status_code: 200, target: %Pinger.Target{active: true, address: "https://www.google.com", interval: 10000, name: "Google"}}
  """
  def new(%Target{} = target, status_code, cause \\ nil) when is_integer(status_code) do
    report = %__MODULE__{
      target: target,
      status_code: status_code,
      cause: cause
    }

    Logger.debug "New report created #{report}"
    report
  end

  @doc """
  ## Example
      iex> Pinger.Target.get_google
      ...> |> Pinger.Report.new(200)
      ...> |> Pinger.Report.update_status_code(500)
      %Pinger.Report{cause: nil, status_code: 500, target: %Pinger.Target{active: true, address: "https://www.google.com", interval: 10000, name: "Google"}}
  """
  def update_status_code(%__MODULE__{} = report, status_code) when is_integer(status_code) do
    %{ report | status_code: status_code}
  end

  @doc """
  ## Example
      iex> Pinger.Target.get_google
      ...> |> Pinger.Report.new(200)
      ...> |> Pinger.Report.update_cause("An error occurred")
      %Pinger.Report{cause: "An error occurred", status_code: 200, target: %Pinger.Target{active: true, address: "https://www.google.com", interval: 10000, name: "Google"}}
  """
  def update_cause(%__MODULE__{} = report, cause) when is_binary(cause) do
    %{ report | cause: cause}
  end
end