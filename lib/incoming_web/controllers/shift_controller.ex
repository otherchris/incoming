defmodule IncomingWeb.ShiftController do
  use IncomingWeb, :controller

  def index(conn, params) do
    render(conn, "index.html")
  end

  def sign_up(conn, params) do
    a = Enum.filter(params["shift"], fn({k, v}) -> v == "true" end)
    redirect(conn, to: "/")
  end
end