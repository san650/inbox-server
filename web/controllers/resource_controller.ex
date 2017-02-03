defmodule Inbox.ResourceController do
  use Inbox.Web, :controller

  def create(conn, %{"resource" => resource_params}) do
    changeset = Inbox.Resource.changeset(%Inbox.Resource{}, resource_params)

    case Inbox.Repo.insert(changeset) do
      {:ok, resource} ->
        render conn, "show.json", resource: resource
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render("error.json", changeset: changeset)
    end
  end
end
