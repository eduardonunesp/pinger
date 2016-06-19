defmodule Pinger.ReportTest do
  use ExUnit.Case
  alias Pinger.Target
  alias Pinger.Report
  doctest Pinger.Report

  setup do
    target = Target.new("Google", "https://google.com")
    report = Report.new(target, 200);
    {:ok, target: target, report: report}
  end

  describe "the report" do
    @describetag :report

    test "should register 200", %{report: report} do
      report = Report.update_status_code(report, 200)
      assert report.status_code == 200, "Result must be 200"
    end

    test "should register 404", %{report: report} do
      report = Report.update_status_code(report, 404)
      assert report.status_code == 404, "Result must be 404"
    end
  end
end
