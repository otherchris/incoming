defmodule Incoming.User do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias Incoming.{Repo, Shift, User}

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field :phone, :string
    field :email, :string
    field :display_name, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
    field :pending_phone_confirmation_code, :string
    field :phone_confirmed, :boolean
    has_many :shifts, Shift
    timestamps()
  end

  def changeset(struct, params) do
    params = clean_phone(params)
    struct
    |> cast(params, [:email, :password, :display_name, :phone, :pending_phone_confirmation_code, :phone_confirmed])
    |> validate_required([:email, :password, :display_name, :phone])
    |> validate_length(:phone, is: 10)
    |> validate_confirmation(:password, required: true)
    |> unique_constraint(:email)
    |> put_encrypted_password()
  end

  defp clean_phone(params = %{phone: phone}) do
    params
    |> Map.put(:phone, String.replace(phone, ~r/[^\d]/, ""))
  end

  def insert(params) do
    cs = changeset(%User{}, params)
    Repo.insert(cs)
  end

  def get_user(id) do
    Repo.get(User, id)
  end

  def get_by_email(email) do
    Repo.get_by(User, email: email)
  end

  def get_shifts_for_user_id(id) do
    user = get_user(id)
    Repo.all(Ecto.assoc(user, :shifts))
  end

  defp put_encrypted_password(%{valid?: true, changes: %{password: pw}} = changeset) do
    put_change(changeset, :hashed_password, Argon2.hash_pwd_salt(pw))
  end

  defp put_encrypted_password(changeset) do
    changeset
  end
end
