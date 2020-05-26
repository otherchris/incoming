defmodule IncomingWeb.ShiftView do
  use IncomingWeb, :view

  @type date_view_type() :: %{label: String.t(), value: String.t()}

  @spec shift_time_list(integer()) :: list(date_view_type)
  def shift_time_list(days_in_future) do
    0..47
    |> Enum.map(fn n ->
      offset_datetime(DateTime.utc_now(), days_in_future, n)
      |> date_view()
    end)
  end

  @spec date_view(DateTime.t()) :: date_view_type()
  def date_view(dt) do
    %{
      label: DateTime.to_string(dt),
      value: DateTime.to_iso8601(dt)
    }
  end

  @spec offset_datetime(DateTime.t(), integer(), integer()) :: String.t()
  def offset_datetime(dt, day_offset, half_hour_offset) do
    dt
    |> start_of_day
    |> DateTime.add(day_offset * 24 * 60 * 60, :second)
    |> DateTime.add(half_hour_offset * 30 * 60, :second)
  end

  @spec start_of_day(DateTime.t()) :: DateTime.t()
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
end
