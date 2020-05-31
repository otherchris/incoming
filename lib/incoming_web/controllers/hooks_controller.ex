defmodule IncomingWeb.HooksController do
  @moduledoc false

  use IncomingWeb, :controller

  def incoming_voice(conn, params) do
    pid = Process.whereis(:dialer)
    resp = IncomingDialer.incoming_call(:dialer, params)
    conn
    |> put_resp_header("content-type", "text/xml")
    |> send_resp(200, resp)
    |> IO.inspect
  end

  def end_call(conn, params) do
    pid = Process.whereis(:dialer)

    resp = IncomingDialer.end_call(:dialer, params)
    conn
    |> send_resp(200, ":ok")
  end
end