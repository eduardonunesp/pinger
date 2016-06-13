defmodule Pinger.ReportTest do
  use ExUnit.Case, async: true
  alias Pinger.Destiny
  alias Pinger.Report

  setup do
    destiny = Destiny.new("Google", "https://google.com")
    report = Report.new(destiny, 200);
    {:ok, destiny: destiny, report: report}
  end

  describe "the report" do
    test "should register 200", %{report: report} do
      report = Report.update_result(report, 200)
      assert report.result == 200, "Result must be 200"
    end

    test "should register 404", %{report: report} do
      report = Report.update_result(report, 404)
      assert report.result == 404, "Result must be 404"
    end
  end
end