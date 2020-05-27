defmodule IncomingWeb.ShiftView do
  use IncomingWeb, :view
  use Timex

  alias Timex.Format.DateTime.Formatters.Strftime

  alias Incoming.Shift


  def shift_time_list(days_in_future) do
    0..47
    |> Enum.map(fn n ->
      offset_datetime(DateTime.utc_now(), days_in_future, n)
      |> date_view()
    end)
  end

  def date_view(dt) do
    {:ok, e_dt} = DateTime.shift_zone(dt, "America/New_York") 
    {:ok, day_label} = Strftime.format(e_dt, "%a,  %b %d, %Y")
    {:ok, time_label} = Strftime.format(e_dt, "%H:%M")
    %{
      day_label: day_label,
      time_label: time_label,
      value: DateTime.to_iso8601(dt)
    }
  end

  def offset_datetime(dt, day_offset, half_hour_offset) do
    dt
    |> start_of_day
    |> DateTime.add(day_offset * 24 * 60 * 60, :second)
    |> DateTime.add(60 * 60 * 4, :second) # Looks good in eastern
    |> DateTime.add(half_hour_offset * 30 * 60, :second)
  end

  def start_of_day(time) do
    time
    |> DateTime.to_iso8601()
    |> String.split("T")
    |> List.first()
    |> Kernel.<>("T00:00:00Z")
    |> DateTime.from_iso8601()
    |> drop_ok
  end

  def drop_ok({:ok, a, 0}), do: a

  def is_past(dts) do
    {:ok, dt, _} = DateTime.from_iso8601(dts)
    DateTime.utc_now() > dt
  end

  def class(:past, dts) do
    if is_past(dts) do
      "past"
    else
      ""
    end
  end

  def sort_shifts(list_of_shifts) do
    Enum.sort_by(list_of_shifts, fn(s) -> s.start end)
  end
end
