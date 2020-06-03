defmodule IncomingWeb.LayoutView do
  use IncomingWeb, :view

  alias IncomingWeb.Authentication

  def user_or_nil(conn) do
    Authentication.get_current_user(conn)
  end

  def receiving_calls?(conn) do
    %{phone: phone} = Authentication.get_current_user(conn)
    %{incoming_numbers: inc_nums} = Process.whereis(:dialer) |> :sys.get_state()
    Enum.member?(inc_nums, phone)
  end
end
