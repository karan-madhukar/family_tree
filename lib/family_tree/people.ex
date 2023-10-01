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

  def get_count(relationship, name) do
    with %Person{} = person <- get_person_by_name(name) do
      case relationship do
        "sons" ->
          relationship1 = get_relationship_by_name("son")
          relationship2 = get_relationship_by_name("father")
          get_relation_count(relationship1, relationship2, person)

        "daughters" ->
          relationship1 = get_relationship_by_name("daughter")
          get_relation_count(relationship1, nil, person)

        "wives" ->
          relationship1 = get_relationship_by_name("wife")
          relationship2 = get_relationship_by_name("husband")
          get_relation_count(relationship1, relationship2, person)

        _ ->
          "Error: Currently this relationship is not handled."
      end
    else
      nil -> "Error: Person with name #{name} doesn't exists."
    end
  end

  defp get_relation_count(nil, nil, _person), do: "Error: relationship doesn't exists"

  defp get_relation_count(nil, relationship2, person) do
    from(c in Connection,
      where: c.person1_id == ^person.id and c.relationship_id == ^relationship2.id
    )
    |> Repo.aggregate(:count)
  end

  defp get_relation_count(relationship1, nil, person) do
    from(c in Connection,
      where: c.person2_id == ^person.id and c.relationship_id == ^relationship1.id
    )
    |> Repo.aggregate(:count)
  end

  defp get_relation_count(relationship1, relationship2, person) do
    from(c in Connection,
      where:
        (c.person1_id == ^person.id and c.relationship_id == ^relationship2.id) or
          (c.person2_id == ^person.id and c.relationship_id == ^relationship1.id)
    )
    |> Repo.aggregate(:count)
  end

  def get_father_name(name) do
    with %Person{} = person <- get_person_by_name(name) do
      case get_father_connection(person) do
        %Connection{} = connection when connection.relationship.name in ["son", "daughter"] ->
          connection.person2.name

        %Connection{} = connection when connection.relationship.name == "father" ->
          connection.person1.name

        nil ->
          "Error: There is no such connection available."
      end
    else
      nil -> "Error: Person with name #{name} doesn't exists."
    end
  end

  defp get_father_connection(person) do
    relationship1 = get_relationship_by_name("son")
    relationship2 = get_relationship_by_name("father")
    relationship3 = get_relationship_by_name("daughter")

    from(c in Connection,
      where:
        (c.person1_id == ^person.id and c.relationship_id == ^relationship1.id) or
          (c.person1_id == ^person.id and c.relationship_id == ^relationship3.id) or
          (c.person2_id == ^person.id and c.relationship_id == ^relationship2.id),
      preload: [:person1, :person2, :relationship]
    )
    |> Repo.one()
  end
end
