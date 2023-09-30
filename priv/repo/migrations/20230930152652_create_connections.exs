defmodule FamilyTree.Repo.Migrations.CreateConnections do
  use Ecto.Migration

  def change do
    create table(:connections) do
      add :person1_id, references("people", on_delete: :delete_all), null: false
      add :person2_id, references("people", on_delete: :delete_all), null: false
      add :relationship_id, references("relationships", on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:connections, [:person1_id, :person2_id])
  end
end
