defmodule IncomingWeb.UserControllerTest do
  @moduledoc false

  use IncomingWeb.ConnCase
  alias Incoming.{Repo, User}

  @good_user %{
    "display_name" => "Guy Incognito",
    "email" => "me@example.com",
    "password" => "password",
    "password_confirmation" => "password",
    "phone" => "(502) 555-1234"
  }

  describe "post /users" do
    test "inserts the user" do
      before_count = Repo.all(User) |> length

      conn =
        build_conn()
        |> post("/users", %{"user" => @good_user})

      after_count = Repo.all(User) |> length
      assert before_count + 1 == after_count
    end
  end

  describe "post /confirm_phone" do
    test "does a thing" do
    end
  end
end
