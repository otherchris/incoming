defmodule IncomingWeb.ShiftControllerTest do
  @moduledoc false

  use IncomingWeb.ConnCase
  alias Incoming.{Repo, Shift, User}
  alias IncomingWeb.Authentication

  import Incoming.Factory

  @time1 "2020-01-01T00:00:00Z"
  @time2 "2020-01-01T00:30:00Z"
  @time3 "2020-01-02T00:30:00Z"
  @badtime "2020-01-01T00:12:00Z"
  @nottime "kljdsic"

  setup do
    d = Process.whereis(:dialer)
    IncomingDialer.set_incoming_numbers(d, [])
    user = insert(:user)
    %{user: user, d: d}
  end

  describe "post /shifts/sign-up" do
    test "inserts the requested shifts", %{user: user} do
      before_count = Repo.all(Shift) |> length

      build_conn()
      |> Authentication.log_in(user)
      |> post("/shifts/sign-up", %{
        "shift" => %{
          "start" => %{
            "year" => "2020",
            "month" => "1",
            "day" => "1",
            "hour" => "13",
            "minute" => "5"
          },
          "stop" => %{
            "year" => "2020",
            "month" => "1",
            "day" => "1",
            "hour" => "14",
            "minute" => "6"
          }
        }
      })

      after_count = Repo.all(Shift) |> length
      assert after_count == before_count + 1

      {:ok, dt, 0} = DateTime.from_iso8601("2020-01-01T17:05:00Z")
      {:ok, [shift]} = Shift.get_by_start(dt)
    end
  end

  describe "post /shifts/switch" do
    test "switch on", %{user: user, d: d} do
      build_conn
      |> Authentication.log_in(user)
      |> post("/shifts/switch", %{"on" => ""})

      %{incoming_numbers: inc_nums} = :sys.get_state(d)
      assert Enum.member?(inc_nums, user.phone)
    end

    test "switch off", %{user: user, d: d} do
      IncomingDialer.add_incoming_number(d, user.phone)

      build_conn
      |> Authentication.log_in(user)
      |> post("/shifts/switch", %{"off" => ""})

      %{incoming_numbers: inc_nums} = :sys.get_state(d)
      assert inc_nums == []
    end
  end
end
