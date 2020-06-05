defmodule Incoming.ShifterTest do
  @moduledoc false

  use ExUnit.Case
  use Incoming.DataCase

  import Incoming.Factory

  def get_now do
    DateTime.utc_now()
    |> DateTime.truncate(:second)
    |> Map.put(:second, 0)
  end

  setup do
    shifter = Process.whereis(:shifter)
    dialer = Process.whereis(:dialer)
    IncomingDialer.set_incoming_numbers(dialer, [])
    %{s: shifter, d: dialer}
  end

  describe "add a phone number for a shift" do
    test "apply numbers", %{d: d, s: s} do
      shift_time =
        DateTime.utc_now()
        |> DateTime.truncate(:second)
        |> Map.put(:second, 0)

      %{id: id1} = insert(:user)
      insert(:shift, %{user_id: id1, start: shift_time, phone: "phone1"})

      Process.send(s, {:shift, get_now()}, [])
      Process.sleep(10)
      :sys.get_state(s)
      %{incoming_numbers: inc_num} = :sys.get_state(d)
      assert inc_num == ["phone1"]
    end
  end
end
