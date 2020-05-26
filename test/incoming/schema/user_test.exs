defmodule Incoming.UserTest do
  @moduledoc false

  use Incoming.DataCase

  alias Incoming.User
  alias Incoming.Repo

  @good_user %{
    display_name: "Guy Incognito",
    email: "me@example.com",
    password: "password",
    password_confirmation: "password"
  }

  describe "create a user" do
    test "changeset is valid with good params" do
      cs = User.changeset(%User{}, @good_user)
      assert cs.valid?
    end

    test "a valid changeset will insert" do
      cs = User.changeset(%User{}, @good_user)
      assert cs.valid?

      before_count = Repo.all(User) |> length
      Repo.insert(cs)
      after_count = Repo.all(User) |> length
      assert before_count + 1 == after_count
    end
  end

  describe "required fields" do
    test "email is required on the changeset" do
      bad_user = Map.delete(@good_user, :email)
      cs = User.changeset(%User{}, bad_user)
      refute cs.valid?
    end

    test "display_name is required on the changeset" do
      bad_user = Map.delete(@good_user, :display_name)
      cs = User.changeset(%User{}, bad_user)
      refute cs.valid?
    end

    test "password is required on the changeset" do
      bad_user = Map.delete(@good_user, :password)
      cs = User.changeset(%User{}, bad_user)
      refute cs.valid?
    end

    test "password confirmation must match" do
      bad_user = Map.put(@good_user, :password_confirmation, "berf")
      cs = User.changeset(%User{}, bad_user)
      refute cs.valid?
    end
  end

  describe "queries" do
    test "get_by_email" do
      User.insert(@good_user)
      user = User.get_by_email(@good_user.email)
      assert user.display_name == @good_user.display_name
    end
  end
end
