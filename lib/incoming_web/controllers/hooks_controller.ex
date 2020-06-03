defmodule IncomingWeb.HooksController do
  @moduledoc false

  use IncomingWeb, :controller

  def incoming_voice(conn, params) do
    d = Process.whereis(:dialer)
    resp = IncomingDialer.incoming_call(d, params)

    conn
    |> put_resp_header("content-type", "text/xml")
    |> send_resp(200, resp)
  end

  def end_call(conn, params) do
    d = Process.whereis(:dialer)

    IncomingDialer.end_call(d, params)

    conn
    |> send_resp(200, ":ok")
  end
end
