defmodule Incoming.User do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias Incoming.{Repo, User}

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field :email, :string
    field :display_name, :string
    field :password, :string, virtual: true
    field :hashed_password, :string

    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:email, :password, :display_name])
    |> validate_required([:email, :password, :display_name])
    |> validate_confirmation(:password, required: true)
    |> unique_constraint(:email)
    |> put_encrypted_password()
  end

  def insert(params) do
    cs = changeset(%User{}, params)
    Repo.insert(cs)
  end

  defp put_encrypted_password(%{valid?: true, changes: %{password: pw}} = changeset) do
    put_change(changeset, :hashed_password, Argon2.hash_pwd_salt(pw))
  end

  defp put_encrypted_password(changeset) do
    changeset
  end
end