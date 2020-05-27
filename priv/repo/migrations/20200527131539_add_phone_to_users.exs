defmodule Incoming.Repo.Migrations.AddPhoneToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :phone, :string, null: false
    end
  end
end
