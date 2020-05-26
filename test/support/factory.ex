defmodule Incoming.Factory do
  # with Ecto
  use ExMachina.Ecto, repo: Incoming.Repo

  def user_factory do
    %Incoming.User{
      display_name: "Howdy Hoo",
      email: sequence(:email, &"email-#{&1}@example.com"),
      hashed_password: "pass"
    }
  end
end
