defmodule IncomingWeb.UserController do
  @moduledoc false

  use IncomingWeb, :controller

  alias Incoming.Environment, as: E
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

    conf_code =
      if E.env() != :prod do
        "999999"
      else
        make_conf_code
      end

    {:ok, user} =
      User.insert(%{
        email: email,
        password: password,
        password_confirmation: password_confirmation,
        display_name: display_name,
        phone: phone,
        pending_phone_confirmation_code: conf_code
      })

    pid = Process.whereis(:dialer)
    if E.env() != :prod do
      IncomingDialer.send_sms(pid, "DEV MODE, FAKE CODE IS 999999", "+1#{user.phone}")
    else
      IncomingDialer.send_sms(pid, "Incoming app confirmation code: #{conf_code}", "+1#{user.phone}")
    end

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

  def make_conf_code, do: make_conf_code([])
  def make_conf_code(list) do
    if length(list) >= 6 do
      list
      |> Enum.map(&Integer.to_string(&1))
      |> Enum.join("")
    else
      list ++ [:rand.uniform(9)] |> make_conf_code
    end
  end
end
