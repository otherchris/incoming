defmodule Incoming.Factory do
  @moduledoc false
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
    %Incoming.Shift{
      start: DateTime.utc_now(),
      stop: DateTime.utc_now(),
      phone: "5025551111",
      user_id: "REPLACE"
    }
  end
end
