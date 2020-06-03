defmodule IncomingWeb.HooksControllerTest do
  @moduledoc false

  use IncomingWeb.ConnCase

  describe "handle an incoming call" do
    test "get twiml from the dialer" do
      build_conn()
      |> post("/api/hooks/incoming-voice", %{"CallSid" => "a", "CallNumber" => "234"})
    end
  end
end
