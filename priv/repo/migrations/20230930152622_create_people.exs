defmodule FamilyTree.Repo.Migrations.CreatePeople do
  use Ecto.Migration

  def change do
    create table(:people) do
      add :name, :string, null: false

      timestamps()
    end
  end
end
