defmodule Inbox.ResourceController do
  use Inbox.Web, :controller
  plug :reacomodate_tags_params, only: ["create"]
  plug :put_request_type, only: ["index"]

  alias Inbox.Resource

  defp put_request_type(conn, _opts) do
    accepts = hd(Plug.Conn.get_req_header(conn, "accept"))

    type = case "json" in MIME.extensions(accepts) do
      true -> :json
      false -> :text
    end

    Plug.Conn.assign(conn, :request_type, type)
  end

  def index(conn, _params) do
    resources = Repo.all(Resource) |> Repo.preload(:tags)

    case conn.assigns[:request_type] do
      :json -> render(conn, "index.json", resources: resources)
      :text -> render(conn, "index.txt", resources: resources)
    end
  end

  def create(conn, %{"resource" => resource_params, "tags" => tag_params}) do
    changeset = Resource.changeset_with_tags(%Resource{}, resource_params, tag_params)

    case Repo.insert(changeset) do
      {:ok, resource} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", resource_path(conn, :show, resource))
        |> render("show.json", resource: resource)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Inbox.ChangesetView, "error.json", changeset: changeset)
    end
  end

  defp reacomodate_tags_params(conn, _opts) do
    conn
    |> Plug.Conn.fetch_query_params
    |> put_params(extract_tags_param(conn.params))
  end

  defp put_params(conn, params) do
    %Plug.Conn{conn|params: params}
  end

  defp extract_tags_param(params) do
    resource = Map.get(params, "resource")

    if resource do
      tags = Map.get(resource, "tags", %{})
      resource = Map.delete(resource, "tags")

      params
      |> Map.put("resource", resource)
      |> Map.put("tags", tags)
    else
      params
    end
  end

  def show(conn, %{"id" => id}) do
    resource = Repo.get!(Resource, id) |> Repo.preload(:tags)
    render(conn, "show.json", resource: resource)
  end

  def update(conn, %{"id" => id, "resource" => resource_params}) do
    resource = Repo.get!(Resource, id) |> Repo.preload(:tags)
    changeset = Resource.changeset(resource, resource_params)

    case Repo.update(changeset) do
      {:ok, resource} ->
        render(conn, "show.json", resource: resource)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Inbox.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    resource = Repo.get!(Resource, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(resource)

    send_resp(conn, :no_content, "")
  end
end
