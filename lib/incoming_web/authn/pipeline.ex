defmodule IncomingWeb.Authentication.Pipeline do
  @moduledoc false
  use Guardian.Plug.Pipeline,
    otp_app: :incoming,
    error_handler: IncomingWeb.Authentication.ErrorHandler,
    module: IncomingWeb.Authentication

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true
end
