defmodule Inbox.Resource do
  use Inbox.Web, :model

  schema "resources" do
    field :uri, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ :empty) do
    struct
    |> cast(params, [:uri])
    |> validate_required([:uri])
    |> unique_constraint(:uri)
  end
end
