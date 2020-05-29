defmodule IncomingWeb.HooksController do
  @moduledoc false

  use IncomingWeb, :controller

  def incoming_voice(conn, params) do
    pid = Process.whereis(:dialer)
    resp = IncomingDialer.incoming_call(:dialer, params)
    send_resp(conn, 200, resp)
  end
end