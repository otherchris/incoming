defmodule IncomingWeb.ShiftView do
  use IncomingWeb, :view
  use Timex

  alias Timex.Format.DateTime.Formatters.Strftime

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

  def is_past(dt) do
    DateTime.utc_now() > dt
  end

  def class(:past, dt) do
    if DateTime.compare(dt, DateTime.utc_now()) == :lt do
      "past"
    else
      ""
    end
  end

  def sort_shifts(list_of_shifts) do
    Enum.sort_by(list_of_shifts, fn s -> s.start end)
  end
end
