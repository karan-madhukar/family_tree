defmodule FamilyTree.People.Person do
  use Ecto.Schema
  import Ecto.Changeset

  schema "people" do
    field(:name, :string)

    timestamps()
  end

  def changeset(person, attrs) do
    person
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> update_change(:name, &String.trim/1)
    |> validate_length(:name, max: 50)
  end
end
