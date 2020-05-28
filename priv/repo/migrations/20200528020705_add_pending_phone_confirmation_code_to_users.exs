defmodule Incoming.Repo.Migrations.AddPendingPhoneConfirmationCodeToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :pending_phone_confirmation_code, :string
      add :phone_confirmed, :boolean
    end
  end
end
