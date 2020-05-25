defmodule IncomingWeb.ShiftController do
  use IncomingWeb, :controller

  def index(conn, params) do
    render(conn, "index.html")
  end
end