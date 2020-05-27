defmodule IncomingWeb.ShiftController do
  use IncomingWeb, :controller

  alias Incoming.Shift
  alias IncomingWeb.Authentication

  def index(conn, params) do
    render(conn, "index.html")
  end

  def sign_up(conn, params) do
    %{id: user_id} = Authentication.get_current_user(conn)

    shifts =
      params
      |> Map.get("shifts")
      |> Enum.filter(fn {k, v} -> v == "true" end)
      |> Enum.map(fn {sdt, _} -> DateTime.from_iso8601(sdt) end)
      |> Enum.each(fn {:ok, dt, _} -> Shift.insert(%{start: dt, user_id: user_id}) end)

    redirect(conn, to: "/dashboard")
  end
end
