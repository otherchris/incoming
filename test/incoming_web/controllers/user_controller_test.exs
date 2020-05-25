defmodule IncomingWeb.UserControllerTest do
  @moduledoc false

  use IncomingWeb.ConnCase
  alias Incoming.{Repo, User}

  @good_user %{
    "display_name" => "Guy Incognito",
    "email" => "me@example.com",
    "password" => "password",
    "password_confirmation" => "password"
  }

  describe "post /users" do
    test "inserts the user" do
      before_count = Repo.all(User) |> length
      build_conn()
      |> post("/users", %{ "user" => @good_user })
      after_count = Repo.all(User) |> length
      assert after_count == before_count + 1
    end
  end
end