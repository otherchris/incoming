defmodule IncomingWeb.PageController do
  use IncomingWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
