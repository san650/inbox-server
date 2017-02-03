defmodule Inbox.Resource do
  use Inbox.Web, :model

  schema "resources" do
    field :url, :binary

    timestamps
  end

  def changeset(model = %Inbox.Resource{}, params) do
    model
    |> cast(params, ~w(url))
    |> validate_required(:url)
    |> unique_constraint(:url)
  end
end
