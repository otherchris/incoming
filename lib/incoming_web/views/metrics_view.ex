defmodule IncomingWeb.MetricsView do
  @moduledoc false

  use IncomingWeb, :view

  def dialer do
    :dialer
    |> Process.whereis
    |> :sys.get_state
  end
end
