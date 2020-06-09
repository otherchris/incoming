defmodule IncomingWeb.ShiftController do
  use IncomingWeb, :controller

  alias Incoming.Shift
  alias IncomingWeb.Authentication

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def errors_to_msg([{_, {msg, _}} | _]), do: msg

  def sign_up(conn, %{"shift" => %{"start" => start, "stop" => stop}}) do
    user = Authentication.get_current_user(conn)

    {:ok, start} = datetime_from_html_dt(start) |> DateTime.shift_zone("Etc/UTC")
    {:ok, stop} = datetime_from_html_dt(stop) |> DateTime.shift_zone("Etc/UTC")

    case Shift.insert(%{start: start, stop: stop, user_id: user.id, phone: user.phone}) do
      {:ok, _} ->
        redirect(conn, to: "/dashboard")
        conn.halt()
      {:error, :invalid, cs} ->
        conn
        |> put_flash(:error, cs.errors |> errors_to_msg)
        |> render("index.html")
    end
  end

  def switch(conn, %{"off" => _}) do
    %{phone: phone} = Authentication.get_current_user(conn)
    pid = Process.whereis(:dialer)
    IncomingDialer.remove_incoming_number(pid, phone)
    redirect(conn, to: "/shifts")
  end

  def switch(conn, %{"on" => _}) do
    %{phone: phone} = Authentication.get_current_user(conn)
    pid = Process.whereis(:dialer)
    IncomingDialer.add_incoming_number(pid, phone)
    redirect(conn, to: "/shifts")
  end

  defp datetime_from_html_dt(
         html_dt = %{"year" => _, "month" => _, "day" => _, "hour" => _, "minute" => _}
       ) do
    base = DateTime.utc_now()

    data =
      Enum.reduce(html_dt, %{}, fn {k, v}, acc ->
        {int, _} = Integer.parse(v)
        Map.put(acc, String.to_atom(k), int)
      end)

    data =
      data
      |> Map.put(:second, 0)
      |> Map.put(:time_zone, "America/New York")
      |> Map.put(:utc_offset, -4 * 60 * 60)

    Map.merge(base, data)
  end
end
