defmodule Incoming.Factory do
  # with Ecto
  use ExMachina.Ecto, repo: Incoming.Repo

  def user_factory do
    %Incoming.User{
      display_name: "Howdy Hoo",
      email: sequence(:email, &"email-#{&1}@example.com"),
      hashed_password: "pass",
      phone: "(502) 555-1234"
    }
  end

  def shift_factory do
    %Incoming.Shift{}
  end
end
