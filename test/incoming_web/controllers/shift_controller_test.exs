defmodule IncomingWeb.ShiftControllerTest do
  @moduledoc false

  use IncomingWeb.ConnCase
  alias Incoming.{Repo, Shift}

  @time1  "2020-01-01T00:00:00Z"
  @time2  "2020-01-01T00:30:00Z"
  @time3  "2020-01-02T00:30:00Z"
  @badtime  "2020-01-01T00:12:00Z"
  @nottime  "kljdsic"

  describe "post /shifts/sign-up" do
    test "inserts the requested shifts" do
      before_count = Repo.all(Shift) |> length
      build_conn()
      |> post("/shifts/sign-up", %{ "shifts" => %{@time1 => "true", @time2 => "false", @time3 => "true"}})
      after_count = Repo.all(Shift) |> length
      assert after_count == before_count + 2

      {:ok, dtime1, _} = DateTime.from_iso8601(@time1)
      {:ok, [shift]} = Shift.get_by_start(@time1)
      assert dtime1 == shift.start
    end
  end
end