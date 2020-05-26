defmodule Incoming.ShiftTest do
  @moduledoc false

  use Incoming.DataCase

  alias Incoming.Shift
  alias Incoming.Repo

  import Incoming.Factory

  describe "operations" do
    test "can insert a shift" do 
      %{id: user_id} = insert(:user)
      before = Repo.all(Shift) |> length
      {:ok, _} = Shift.insert(%{start: DateTime.utc_now, user_id: user_id})
      aafter = Repo.all(Shift) |> length
      assert aafter == before + 1
    end

    test "insert truncates the start" do
      %{id: user_id} = insert(:user)
      now = DateTime.utc_now()
      {:ok, _} = Shift.insert(%{start: now, user_id: user_id})
      {:ok, [shift]} = Shift.get_by_start(now)

      refute shift.start == now
      assert shift.start == DateTime.truncate(now, :second)
    end
  end 

  describe "required fields" do
    test "start is required in the db schema" do
      assert_raise Postgrex.Error, fn -> Repo.insert(%Shift{}) end
    end

    test "start is required on the changeset" do
      cs = Shift.changeset(%Shift{}, %{})
      refute cs.valid?
    end
  end

  describe "queries" do
    test "get_by_start" do
      %{id: user_id} = insert(:user)
      now = DateTime.utc_now
      %{start: now, user_id: user_id}
      |> Shift.insert

      {:ok, [shift]} = Shift.get_by_start(now)
      assert shift.start == DateTime.truncate(now, :second)
    end
  end
end