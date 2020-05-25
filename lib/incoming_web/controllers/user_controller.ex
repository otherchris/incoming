defmodule IncomingWeb.UserController do
  @moduledoc false

  use IncomingWeb, :controller

  alias Incoming.User

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, params) do
    %{
      "email" => email,
      "password" => password,
      "password_confirmation" => password_confirmation,
      "display_name" => display_name
    } = params["user"]
    User.insert(%{
      email: email,
      password: password,
      password_confirmation: password_confirmation,
      display_name: display_name
    })
    redirect(conn, to: "/")
  end
end