defmodule FamilyTree.People do
  import Ecto.Query, warn: false

  alias FamilyTree.Repo
  alias FamilyTree.People.{Connection, Person, Relationship}

  defp get_person_by_name(name) do
    from(p in Person,
      where: ilike(p.name, ^name)
    )
    |> Repo.one()
  end

  def add_person(name) do
    case create_person(name) do
      {:ok, %Person{}} ->
        "PERSON WITH NAME #{name} HAS BEEN ADDED SUCCESSFULLY."

      {:error, %Ecto.Changeset{errors: [name: {message, _}]}} ->
        "Error: Name #{message}."
    end
  end

  defp create_person(name) do
    %Person{}
    |> Person.changeset(%{name: name})
    |> Repo.insert()
  end

  defp get_relationship_by_name(name) do
    from(r in Relationship,
      where: ilike(r.name, ^name)
    )
    |> Repo.one()
  end

  def add_relationship(name) do
    case create_relationship(name) do
      {:ok, %Relationship{}} ->
        "RELATIONSHIP WITH NAME #{name} HAS BEEN ADDED SUCCESSFULLY."

      {:error, %Ecto.Changeset{errors: [name: {message, _}]}} ->
        "Error: Name #{message}."
    end
  end

  defp create_relationship(name) do
    %Relationship{}
    |> Relationship.changeset(%{name: name})
    |> Repo.insert()
  end

  defp get_connection(person2_id, person1_id) do
    from(c in Connection,
      where: c.person1_id == ^person2_id and c.person2_id == ^person1_id
    )
    |> Repo.one()
  end

  def add_connection(person1_name, person2_name, relationship_name) do
    person1 = get_person_by_name(person1_name)
    person2 = get_person_by_name(person2_name)
    relationship = get_relationship_by_name(relationship_name)

    with true <- not is_nil(person1) and not is_nil(person2) && not is_nil(relationship),
         nil <- get_connection(person2.id, person1.id),
         {:ok, %Connection{}} <-
           create_connection(%{
             person1_id: person1.id,
             person2_id: person2.id,
             relationship_id: relationship.id
           }) do
      "CONNECTION CREATED SUCCESSFULLY BETWEEN #{person1_name} AND #{person2_name}."
    else
      false ->
        "Error: Ensure that people #{person1_name}, #{person2_name}, and relationship #{relationship_name} are already present in the application."

      {:error, %Ecto.Changeset{errors: [person1_id: {message, _}]}} ->
        "Error: #{message}."

      %Connection{} ->
        "Error: has already been taken."
    end
  end

  defp create_connection(attrs) do
    %Connection{}
    |> Connection.changeset(attrs)
    |> Repo.insert()
  end
end
