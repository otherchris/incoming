defmodule IncomingWeb.ShiftView do
  use IncomingWeb, :view

  def shift_time_list(days_in_future) do
    0..47 |> Enum.map(fn(n) -> 
      offset_datetime(DateTime.utc_now(), days_in_future, n)
      |> date_view()
    end)
  end

  def date_view(dt) do
    DateTime.to_string(dt)
  end

  @spec offset_datetime(DateTime.t(), integer(), integer()) :: String.t
  def offset_datetime(dt, day_offset, half_hour_offset) do
    dt
    |> start_of_day
    |> DateTime.add(day_offset * 24 * 60 * 60, :second)
    |> DateTime.add(half_hour_offset * 30 * 60, :second)
  end  

  @spec start_of_day(DateTime.t()) :: DateTime.t()
  def start_of_day(time) do
    time
    |> DateTime.to_iso8601
    |> String.split("T")
    |> List.first()
    |> Kernel.<>("T00:00:00Z")
    |> DateTime.from_iso8601 
    |> drop_ok
  end

  def drop_ok({:ok, a, 0}), do: a
end