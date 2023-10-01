# FamilyTree

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * build the script with `mix escript.build`

Now you can use the below command to build and query Family Tree.
  * To add a person `escript ./family_tree add person <name>`
  * To add a relationship `escript ./family_tree add relationship <name>`
  * To add a connection `escript ./family-tree connect <name 1> as <relationship> of <name 2>`

  * To get sons count `escript ./family-tree count sons of <name>`
  * To get daughters count `escript ./family-tree count daughters of <name>`
  * To get wives count `escript ./family-tree count wives of <name>`
  * To get father name `escript ./family-tree father of <name>`

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
