defmodule Inbox.ResourceView do
  use Inbox.Web, :view

  def render("index.json", %{resources: resources}) do
    %{data: render_many(resources, Inbox.ResourceView, "one.json")}
  end

  def render("show.json", %{resource: resource}) do
    %{data: render_one(resource, Inbox.ResourceView, "one.json")}
  end

  def render("resource.json", %{resource: resource}) do
    %{data: render_one(resource, Inbox.ResourceView, "one.json")}
  end

  def render("one.json", %{resource: resource}) do
    %{id: resource.id,
      uri: resource.uri,
      created_at: resource.inserted_at,
      updated_at: resource.updated_at,
      tags: for tag <- resource.tags do tag.name end}
  end
end
