defmodule Incoming.ShifterTest do
  @moduledoc false

  use ExUnit.Case
  use Incoming.DataCase

  import Incoming.Factory

  alias Incoming.Now

  setup do
    shifter = Process.whereis(:shifter)
    dialer = Process.whereis(:dialer)
    %{s: shifter, d: dialer}
  end

  describe "apply phone numbers for shift" do
    test "apply numbers", %{d: d, s: s} do
      shift_time = 
        DateTime.utc_now() 
        |> DateTime.add(10000, :second) 
        |> Map.put(:minute, 30) 
        |> Map.put(:second, 0)
        |> DateTime.truncate(:second)
        |> IO.inspect
      %{id: id1} = insert(:user, %{phone: "phone1"})
      %{id: id2} = insert(:user, %{phone: "phone2"})
      insert(:shift, %{user_id: id1, start: shift_time})
      insert(:shift, %{user_id: id1, start: shift_time |> DateTime.add(1, :second)})

      shift_time
      |> Now.set_now()

      Process.send(s, :tick, [])
      :sys.get_state(s)
      Process.sleep(5)
      %{incoming_numbers: inc_num} = :sys.get_state(d)
      assert inc_num == ["phone1"]
    end
  end
end