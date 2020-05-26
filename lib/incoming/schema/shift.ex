defmodule Incoming.Shift do
  @moduledoc false

  alias Incoming.{Repo, Shift, User}
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "shifts" do
    field(:start, :utc_datetime)
    belongs_to(:user, User, foreign_key: :user_id, references: :id, type: :binary_id)

    timestamps()
  end

  @fields ~w()a
  @required_fields ~w(start user_id)a

  def changeset(shift = %Shift{}, attrs = %Shift{}) do
    changeset(shift, Map.from_struct(attrs))
  end

  def changeset(shift = %Shift{}, attrs) do
    attrs = if Map.has_key?(attrs, :start) do
      Map.put(attrs, :start, DateTime.truncate(attrs.start, :second))
    else
      attrs
    end

    shift
    |> cast(attrs, @fields ++ @required_fields)
    |> validate_required(@required_fields)
  end

  def insert(shift) do
    cs = changeset(%Shift{}, shift)
    if cs.valid? do
      Repo.insert(cs)
    else
      {:error, :invalid}
    end
  end 

  def get_by_start(shift) do
    query = from s in Shift,
              where: s.start == ^shift
    {:ok, Repo.all(query)}
  end
end