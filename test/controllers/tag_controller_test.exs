defmodule Inbox.TagControllerTest do
  use Inbox.ConnCase

  alias Inbox.Tag
  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    Repo.insert!(Tag.changeset(%Tag{}, %{name: "foo", group: "foo_group"}))
    Repo.insert!(Tag.changeset(%Tag{}, %{name: "bar"}))
    Repo.insert!(Tag.changeset(%Tag{}, %{name: "baz", system: true}))

    conn = get conn, tag_path(conn, :index)
    response = json_response(conn, 200)["data"]

    assert length(response) == 3
    assert Enum.at(response, 0) == %{"name" => "foo", "group" => "foo_group", "system" => false}
    assert Enum.at(response, 1) == %{"name" => "bar", "group" => "user", "system" => false}
    assert Enum.at(response, 2) == %{"name" => "baz", "group" => "user", "system" => true}
  end
end