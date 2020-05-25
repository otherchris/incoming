defmodule IncomingWeb.SessionController do
  @moduledoc false

  use IncomingWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end
end