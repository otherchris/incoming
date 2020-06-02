defmodule IncomingWeb.UserController do
  @moduledoc false

  use IncomingWeb, :controller

  alias Incoming.{Repo, User}
  alias IncomingWeb.Authentication

  def new(conn, _params) do
    render(conn, "new.html", confirm_phone: false)
  end

  def dashboard(conn, _params) do
    user =
      conn
      |> Authentication.get_current_user()
      |> Repo.preload(:shifts)

    render(conn, "dashboard.html", %{user: user})
  end

  def create(conn, params) do
    %{
      "email" => email,
      "password" => password,
      "password_confirmation" => password_confirmation,
      "display_name" => display_name,
      "phone" => phone
    } = params["user"]

    {:ok, user} =
      User.insert(%{
        email: email,
        password: password,
        password_confirmation: password_confirmation,
        display_name: display_name,
        phone: phone,
        pending_phone_confirmation_code: "999999"
      })

    pid = Process.whereis(:dialer)
    IncomingDialer.send_sms(pid, "Your code, like all codes, is 999999", "+1#{user.phone}")

    conn
    |> render("new.html", confirm_phone: true, user_id: user.id)
  end

  def confirm_phone_and_insert_user(conn, params) do
    %{
      "user_id" => user_id,
      "code" => code
    } = params["phone_confirm"]

    user = Repo.get(User, user_id)

    if user.pending_phone_confirmation_code == code do
      conn
      |> Authentication.log_in(user)
      |> redirect(to: "/dashboard")
    else
      redirect(conn, to: "/register")
    end
  end
end
