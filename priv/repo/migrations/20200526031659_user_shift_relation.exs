defmodule Incoming.Repo.Migrations.UserShiftRelation do
  use Ecto.Migration

  def change do
    alter table(:shifts) do
      add :user_id, references(:users, type: :binary_id)
    end
  end
end
