defmodule FamilyTree.Repo.Migrations.CreateRelationships do
  use Ecto.Migration

  def change do
    create table(:relationships) do
      add(:name, :string, null: false)

      timestamps()
    end

    create unique_index(:relationships, :name)
  end
end
