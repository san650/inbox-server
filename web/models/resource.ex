defmodule Inbox.Resource do
  use Inbox.Web, :model

  schema "resources" do
    field :uri, :string

    timestamps()

    many_to_many :tags,
      Inbox.Tag,
      join_through: "resources_tags",
      on_delete: :delete_all,
      on_replace: :delete,
      unique: true
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ :empty) do
    struct
    |> Inbox.Repo.preload(:tags)
    |> cast(params, [:uri])
    |> validate_required([:uri])
    |> unique_constraint(:uri)
  end

  def changeset_with_tags(struct, params, tag_names) do
    struct
    |> Inbox.Repo.preload(:tags)
    |> cast(params, [:uri])
    |> validate_required([:uri])
    |> unique_constraint(:uri)
    |> Ecto.Changeset.put_assoc(:tags, Inbox.Repo.find_or_create(Inbox.Tag, tag_names))
  end
end
