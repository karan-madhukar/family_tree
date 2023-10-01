defmodule FamilyTree.CLI do
  import FamilyTree.People

  def main(args) do
    case args do
      ["add", "person", first_name, last_name] ->
        handle_add_person("#{first_name} #{last_name}")

      ["add", "person", first_name] ->
        handle_add_person(first_name)

      ["add", "relationship", name] ->
        handle_add_relationship(name)

      [
        "connect",
        p1_first_name,
        p1_last_name,
        "as",
        relationship,
        "of",
        p2_first_name,
        p2_last_name
      ] ->
        handle_add_connection(
          "#{p1_first_name} #{p1_last_name}",
          "#{p2_first_name} #{p2_last_name}",
          relationship
        )

      ["connect", p1_first_name, "as", relationship, "of", p2_first_name, p2_last_name] ->
        handle_add_connection(p1_first_name, "#{p2_first_name} #{p2_last_name}", relationship)

      ["connect", p1_first_name, p1_last_name, "as", relationship, "of", p2_first_name] ->
        handle_add_connection("#{p1_first_name} #{p1_last_name}", p2_first_name, relationship)

      ["connect", p1_first_name, "as", relationship, "of", p2_first_name] ->
        handle_add_connection(p1_first_name, p2_first_name, relationship)

      _ ->
        IO.puts("Invalid command. Please use the below commands.

        # Add a person
        escript ./family_tree add person Amit Dhakad

        # Add a relationship
        escript ./family_tree add relationship father

        # Add a connection
        escript ./family_trees Amit Dhakad as son of KK Dhakad")
        System.halt(1)
    end
  end

  defp handle_add_person(name) do
    IO.inspect(add_person(name))
  end

  defp handle_add_relationship(name) do
    IO.inspect(add_relationship(name))
  end

  defp handle_add_connection(person1_name, person2_name, relationship) do
    IO.inspect(add_connection(person1_name, person2_name, relationship))
  end
end
