defmodule FamilyTree.People.Connections do
  use Ecto.Schema
  import Ecto.Changeset

  alias FamilyTree.People.{Person, Relationship}

  schema "connections" do
    belongs_to :person1, Person
    belongs_to :person2, Person
    belongs_to :relationship, Relationship

    timestamps()
  end

  def changeset(person, attrs) do
    person
    |> cast(attrs, [:person1_id, :person2_id, :relationship_id])
    |> validate_required([:person1_id, :person2_id, :relationship_id])
    |> foreign_key_constraint(:person1_id)
    |> foreign_key_constraint(:person2_id)
    |> foreign_key_constraint(:relationship_id)
    |> unique_constraint([:person1_id, :person2_id])
  end
end
