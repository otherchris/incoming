defmodule Incoming.Now do
  @moduledoc false

  alias Incoming.Environment, as: E

  def utc_now() do
    if E.env() == :test do
      E.now()
    else
      DateTime.utc_now()
    end
  end

  def set_now(dt) do
    Application.put_env(:incoming, :now, dt)
  end
end