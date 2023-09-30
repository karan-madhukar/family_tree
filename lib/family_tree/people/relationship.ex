defmodule FamilyTree.People.Relationship do
  use Ecto.Schema
  import Ecto.Changeset

  schema "relationships" do
    field(:name, :string)

    timestamps()
  end

  def changeset(relationship, attrs) do
    relationship
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> update_change(:name, &String.trim/1)
    |> validate_length(:name, max: 50)
    |> unique_constraint(:name)
  end
end
