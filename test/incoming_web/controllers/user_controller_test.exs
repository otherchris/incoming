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
    test "adds the user params to conn assigns" do
      conn = 
      build_conn()
      |> post("/users", %{"user" => @good_user})

      %{"email" =>  email} = conn.assigns.pending_user
      assert email == @good_user["email"]
    end
  end

  describe "post /confirm_phone" do
    test "inserts the user" do
      before_count = Repo.all(User) |> length
      conn = 
      build_conn
      |> assign(:pending_user, @good_user)
      |> assign(:phone_confirm_code, "999999")
      |> post("/confirm-phone", %{"phone_confirm" => %{"code" => "999999"}})
      after_count = Repo.all(User) |> length
      assert before_count + 1 == after_count
    end
  end
end
