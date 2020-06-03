defmodule Incoming.Environment do
  @moduledoc false

  def now, do: Application.get_env(:incoming, :now)

  def env, do: Mix.env()
end
