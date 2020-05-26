defmodule IncomingWeb.SessionController do
  @moduledoc false

  use IncomingWeb, :controller

  alias Incoming.User
  alias IncomingWeb.Authentication

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case email |> User.get_by_email() |> Authentication.authenticate(password) do
      {:ok, user} ->
        conn
        |> Authentication.log_in(user)
        |> redirect(to: "/shifts")

      {:error, :invalid_credentials} ->
        conn
        |> put_flash(:error, "Incorrect email or password")
        |> new(%{})
    end
  end

  def delete(conn, _params) do
    conn
    |> Authentication.log_out()
    |> redirect(to: "/login")
  end
end