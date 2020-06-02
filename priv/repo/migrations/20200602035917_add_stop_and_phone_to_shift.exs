defmodule Incoming.Repo.Migrations.AddStopAndPhoneToShift do
  use Ecto.Migration

  def change do
    alter table(:shifts) do
      add :stop, :utc_datetime, null: false
      add :phone, :string, null: false
    end
  end
end
