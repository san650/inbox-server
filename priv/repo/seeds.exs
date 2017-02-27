# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Inbox.Repo.insert!(%Inbox.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# Tags

system_tags = %{
  "media"      => ~w(url text video),
  "via"        => ~w(shell mobile browser),
  "status"     => ~w(pending archived),
  "importance" => ~w(important useful clever liked),
  "source"     => ~w(twitter)
}

Enum.each(system_tags, fn {group, names} ->
  Enum.each(names, fn name ->
    Inbox.Repo.insert!(%Inbox.Tag{name: name, group: group, system: true})
  end)
end)

user_tags = %{
  "category"     => ~w(work fun personal),
  "technologies" => ~w(ember angular react vue ruby rails sinatra python elixir phoenix)
}

Enum.each(user_tags, fn {group, names} ->
  Enum.each(names, fn name ->
    Inbox.Repo.insert!(%Inbox.Tag{name: name, group: group, system: true})
  end)
end)
