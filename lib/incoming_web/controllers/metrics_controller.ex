defmodule IncomingWeb.MetricsController do
  use IncomingWeb, :controller

  def index(conn, _params) do
    conn
    render(conn, "index.html")
  end

end
