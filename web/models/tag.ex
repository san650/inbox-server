defmodule Inbox.Tag do
  use Inbox.Web, :model

  schema "tags" do
    field :name, :string
    field :group, :string, default: "user"
    field :system, :boolean, default: false

    timestamps()

    many_to_many :resources,
      Inbox.Resource,
      join_through: "resources_tags",
      on_delete: :delete_all,
      on_replace: :delete,
      unique: true
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :group, :system])
    |> validate_required([:name, :group, :system])
  end
end
