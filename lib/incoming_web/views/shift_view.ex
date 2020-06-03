defmodule IncomingWeb.ShiftView do
  use IncomingWeb, :view
  use Timex

  alias Timex.Format.DateTime.Formatters.Strftime

  alias Incoming.Shift

  def date_view(dt) do
    {:ok, e_dt} = DateTime.shift_zone(dt, "America/New_York")
    {:ok, day_label} = Strftime.format(e_dt, "%a,  %b %-d, %Y")
    {:ok, time_label} = Strftime.format(e_dt, "%H:%M")

    %{
      day_label: day_label,
      time_label: time_label,
      value: DateTime.to_iso8601(dt)
    }
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
    Enum.sort_by(list_of_shifts, fn s -> s.start end)
  end
end
