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

    {:ok, response} = conn
               |> with_valid_auth
               |> get(resource_path(conn, :index))
               |> json_response(200)
               |> Map.fetch("resources")

    assert response
    assert length(response) == 1
    assert List.first(response)["id"] == resource.id
    assert List.first(response)["tags"] == []
  end

  test "list all entries on index as Text", %{conn: conn} do
    Repo.insert!(Resource.changeset_with_tags(%Resource{}, %{uri: "https://www.example.org/"}, ~w(foo bar)))

    resp = conn
           |> with_valid_auth
           |> put_req_header("accept", "text/plain")
           |> get(resource_path(conn, :index))
           |> response(200)

    assert resp == "https://www.example.org/ foo bar\n"
  end

  test "filters entries based on tags as JSON", %{conn: conn} do
    Repo.insert!(Resource.changeset_with_tags(%Resource{}, %{uri: "https://www.example.org/foo"}, ~w(foo bar)))
    Repo.insert!(Resource.changeset_with_tags(%Resource{}, %{uri: "https://www.example.org/bar"}, ~w(foo baz)))
    Repo.insert!(Resource.changeset_with_tags(%Resource{}, %{uri: "https://www.example.org/qux"}, ~w(qux)))

    {:ok, response} = conn
               |> with_valid_auth
               |> get(resource_path(conn, :index), %{"tags" => ~w(foo bar)})
               |> json_response(200)
               |> Map.fetch("resources")

    assert response
    assert length(response) == 1
    assert List.first(response)["uri"] == "https://www.example.org/foo"

    {:ok, response} = conn
               |> with_valid_auth
               |> get(resource_path(conn, :index), %{"tags" => ~w(foo)})
               |> json_response(200)
               |> Map.fetch("resources")

    assert response
    assert length(response) == 2
    assert List.first(response)["uri"] == "https://www.example.org/foo"
    assert List.last(response)["uri"] == "https://www.example.org/bar"
  end

  test "excludes entries based on negated tags as JSON", %{conn: conn} do
    Repo.insert!(Resource.changeset_with_tags(%Resource{}, %{uri: "https://www.example.org/foo"}, ~w(foo bar)))
    Repo.insert!(Resource.changeset_with_tags(%Resource{}, %{uri: "https://www.example.org/bar"}, ~w(foo baz)))
    Repo.insert!(Resource.changeset_with_tags(%Resource{}, %{uri: "https://www.example.org/qux"}, ~w(qux)))

    {:ok, response} = conn
               |> with_valid_auth
               |> get(resource_path(conn, :index), %{"tags" => ~w(foo ~baz)})
               |> json_response(200)
               |> Map.fetch("resources")

    assert response
    assert length(response) == 1
    assert List.first(response)["uri"] == "https://www.example.org/foo"
  end

  test "shows chosen resource", %{conn: conn} do
    resource = Repo.insert! @valid_resource

    {:ok, response} = conn
               |> with_valid_auth
               |> get(resource_path(conn, :show, resource))
               |> json_response(200)
               |> Map.fetch("resource")

    assert response == %{
      "id" => resource.id,
      "uri" => resource.uri,
      "created_at" => NaiveDateTime.to_iso8601(resource.inserted_at),
      "updated_at" => NaiveDateTime.to_iso8601(resource.updated_at),
      "tags" => []}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      conn
      |> with_valid_auth
      |> get(resource_path(conn, :show, -1))
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    {:ok, response} = conn
               |> with_valid_auth
               |> post(resource_path(conn, :create), resource: @valid_post_attrs)
               |> json_response(201)
               |> Map.fetch("resource")

    assert response["id"]
    assert response["tags"] == ~w(foo bar)

    resource = Repo.get_by(Resource, @valid_attrs) |> Inbox.Repo.preload(:tags)

    assert resource
    assert Enum.map(resource.tags, &(&1.name)) == ~w(foo bar)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    {:ok, response} = conn
               |> with_valid_auth
               |> post(resource_path(conn, :create), resource: @invalid_attrs)
               |> json_response(422)
               |> Map.fetch("errors")

    assert response != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    resource = Repo.insert! @valid_resource

    {:ok, response} = conn
               |> with_valid_auth
               |> put(resource_path(conn, :update, resource), resource: @valid_attrs)
               |> json_response( 200)
               |> Map.fetch("resource")

    response = response
               |> Map.fetch("id")

    assert response
    assert Repo.get_by(Resource, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    resource = Repo.insert! @valid_resource

    {:ok, response} = conn
               |> with_valid_auth
               |> put(resource_path(conn, :update, resource), resource: @invalid_attrs)
               |> json_response(422)
               |> Map.fetch("errors")

    assert response != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    resource = Repo.insert! @valid_resource

    resp = conn
           |> with_valid_auth
           |> delete(resource_path(conn, :delete, resource))
           |> response(204)

    assert resp
    refute Repo.get(Resource, resource.id)
  end

  test "requires basic http auth", %{conn: conn} do
    resp = conn
           |> get(resource_path(conn, :index))
           |> response(401)

    assert resp
  end
end
