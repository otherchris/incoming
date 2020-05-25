defmodule Incoming.ShiftTest do
  @moduledoc false

  use Incoming.DataCase

  alias Incoming.Shift
  alias Incoming.Repo

  describe "operations" do
    test "can insert a shift" do 
      before = Repo.all(Shift) |> length
      {:ok, _} = Shift.insert(%{start: DateTime.utc_now})
      aafter = Repo.all(Shift) |> length
      assert aafter == before + 1
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
end