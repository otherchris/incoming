defmodule IncomingWeb.ShiftController do
  use IncomingWeb, :controller

  alias Incoming.Shift

  def index(conn, params) do
    render(conn, "index.html")
  end

  def sign_up(conn, params) do
    shifts = 
      params
      |> Map.get("shifts")
      |> Enum.filter(fn({k, v}) -> v == "true" end)
      |> Enum.map(fn({sdt, _}) -> DateTime.from_iso8601(sdt) end) 
      |> Enum.each(fn({:ok, dt, _}) -> Shift.insert(%{start: dt}) end)
    
    redirect(conn, to: "/")
  end
end