defmodule Inbox.ResourceTest do
  use Inbox.ModelCase

  alias Inbox.Resource

  @valid_attrs %{uri: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Resource.changeset(%Resource{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Resource.changeset(%Resource{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "uri has been taken" do
    resource = Resource.changeset(%Resource{}, @valid_attrs)
    Repo.insert(resource)

    imposter = Resource.changeset(%Resource{}, @valid_attrs)

    assert {:error, changeset} = Repo.insert(imposter)
    assert changeset.errors[:uri] == {"has already been taken", []}
  end
end
