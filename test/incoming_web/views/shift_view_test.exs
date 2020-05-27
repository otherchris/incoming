defmodule IncomingWeb.ShiftViewTest do
  use IncomingWeb.ConnCase, async: true
  use ExUnit.Case

  doctest IncomingWeb.ShiftView

  describe "start_of_day" do
    test "returns datetime of start of day" do
      {:ok, dt, _} = DateTime.from_iso8601("2020-01-01T03:45:32Z")
      {:ok, start, _} = DateTime.from_iso8601("2020-01-01T00:00:00Z")
      assert IncomingWeb.ShiftView.start_of_day(dt) == start
    end
  end

  describe "make_date" do
    test "gives iso string of date offset from given date by days and half hours" do
      {:ok, base, _} = DateTime.from_iso8601("2020-01-01T00:00:00Z")
      {:ok, offset, _} = DateTime.from_iso8601("2020-01-03T01:30:00Z")
      offset = offset |> DateTime.add(4 * 60 * 60, :second)
      assert IncomingWeb.ShiftView.offset_datetime(base, 2, 3) == offset
    end
  end
end
