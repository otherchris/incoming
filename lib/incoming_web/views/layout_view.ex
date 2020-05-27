defmodule IncomingWeb.LayoutView do
  use IncomingWeb, :view

  alias IncomingWeb.Authentication

  def user_or_nil(conn) do
    Authentication.get_current_user(conn)
  end
end
