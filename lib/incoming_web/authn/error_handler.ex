defmodule IncomingWeb.Authentication.ErrorHandler do
  @moduledoc false
  use IncomingWeb, :controller

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> redirect(to: "/login")
  end
end
