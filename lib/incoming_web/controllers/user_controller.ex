defmodule IncomingWeb.UserController do
  @moduledoc false

  use IncomingWeb, :controller

  alias Incoming.{Repo, User}
  alias IncomingWeb.Authentication

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def dashboard(conn, _params) do
    user = 
      conn
      |> Authentication.get_current_user
      |> Repo.preload(:shifts)
    render(conn, "dashboard.html", %{user: user})
  end

  def create(conn, params) do
    %{
      "email" => email,
      "password" => password,
      "password_confirmation" => password_confirmation,
      "display_name" => display_name
    } = params["user"]
    {:ok, user} = User.insert(%{
      email: email,
      password: password,
      password_confirmation: password_confirmation,
      display_name: display_name
    }) 
    conn
    |> Authentication.log_in(user)
    |> redirect(to: "/")
  end
end