defmodule IncomingWeb.Authentication.ErrorHandler do
  use IncomingWeb, :controller

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _reason}, _opts) do
    conn
    |> redirect(to: "/login")
  end
end
