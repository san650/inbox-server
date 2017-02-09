defmodule Inbox.ResourceControllerTest do
  use Inbox.ConnCase

  alias Inbox.Resource
  @valid_post_attrs %{uri: "some content", tags: ~w(foo bar)}
  @valid_attrs %{uri: "some content"}
  @invalid_attrs %{uri: nil}

  @valid_resource %Resource{uri: "some content"}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json, text/javascript, */*; q=0.01")}
  end

  test "lists all entries on index as JSON", %{conn: conn} do
    resource = Repo.insert! @valid_resource
    conn = get conn, resource_path(conn, :index)
    response = json_response(conn, 200)["resources"]

    assert response
    assert length(response) == 1
    assert List.first(response)["id"] == resource.id
    assert List.first(response)["tags"] == []
  end

  test "list all entries on index as Text", %{conn: conn} do
    conn = put_req_header(conn, "accept", "text/plain")

    Repo.insert!(Resource.changeset_with_tags(%Resource{}, %{uri: "https://www.example.org/"}, ~w(foo bar)))

    conn = get conn, resource_path(conn, :index)
    assert response(conn, 200) == "https://www.example.org/ foo bar\n"
  end

  test "filters entries based on tags as JSON", %{conn: conn} do
    Repo.insert!(Resource.changeset_with_tags(%Resource{}, %{uri: "https://www.example.org/foo"}, ~w(foo bar)))
    Repo.insert!(Resource.changeset_with_tags(%Resource{}, %{uri: "https://www.example.org/bar"}, ~w(foo baz)))
    Repo.insert!(Resource.changeset_with_tags(%Resource{}, %{uri: "https://www.example.org/qux"}, ~w(qux)))

    conn = get(conn, resource_path(conn, :index), %{"tags" => ~w(foo bar)})

    response = json_response(conn, 200)["resources"]

    assert response
    assert length(response) == 1
    assert List.first(response)["uri"] == "https://www.example.org/foo"

    conn = get(conn, resource_path(conn, :index), %{"tags" => ~w(foo)})

    response = json_response(conn, 200)["resources"]

    assert response
    assert length(response) == 2
    assert List.first(response)["uri"] == "https://www.example.org/foo"
    assert List.last(response)["uri"] == "https://www.example.org/bar"
  end

  test "excludes entries based on negated tags as JSON", %{conn: conn} do
    Repo.insert!(Resource.changeset_with_tags(%Resource{}, %{uri: "https://www.example.org/foo"}, ~w(foo bar)))
    Repo.insert!(Resource.changeset_with_tags(%Resource{}, %{uri: "https://www.example.org/bar"}, ~w(foo baz)))
    Repo.insert!(Resource.changeset_with_tags(%Resource{}, %{uri: "https://www.example.org/qux"}, ~w(qux)))

    conn = get(conn, resource_path(conn, :index), %{"tags" => ~w(foo ~baz)})

    response = json_response(conn, 200)["resources"]

    assert response
    assert length(response) == 1
    assert List.first(response)["uri"] == "https://www.example.org/foo"
  end

  test "shows chosen resource", %{conn: conn} do
    resource = Repo.insert! @valid_resource
    conn = get conn, resource_path(conn, :show, resource)
    assert json_response(conn, 200)["resource"] == %{
      "id" => resource.id,
      "uri" => resource.uri,
      "created_at" => NaiveDateTime.to_iso8601(resource.inserted_at),
      "updated_at" => NaiveDateTime.to_iso8601(resource.updated_at),
      "tags" => []}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, resource_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, resource_path(conn, :create), resource: @valid_post_attrs
    response = json_response(conn, 201)["resource"]

    assert response["id"]
    assert response["tags"] == ~w(foo bar)

    resource = Repo.get_by(Resource, @valid_attrs) |> Inbox.Repo.preload(:tags)

    assert resource
    assert Enum.map(resource.tags, &(&1.name)) == ~w(foo bar)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, resource_path(conn, :create), resource: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    resource = Repo.insert! @valid_resource
    conn = put conn, resource_path(conn, :update, resource), resource: @valid_attrs
    assert json_response(conn, 200)["resource"]["id"]
    assert Repo.get_by(Resource, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    resource = Repo.insert! @valid_resource
    conn = put conn, resource_path(conn, :update, resource), resource: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    resource = Repo.insert! @valid_resource
    conn = delete conn, resource_path(conn, :delete, resource)
    assert response(conn, 204)
    refute Repo.get(Resource, resource.id)
  end
end
