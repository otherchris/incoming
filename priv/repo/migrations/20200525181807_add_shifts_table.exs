defmodule Incoming.Repo.Migrations.AddShiftsTable do
  use Ecto.Migration

  def change do
    create table(:shifts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :start, :utc_datetime, null: false

      timestamps()
    end
  end
end
