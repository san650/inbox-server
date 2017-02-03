defmodule Inbox.ResourceView do
  use Inbox.Web, :view

  def render("show.json", %{resource: resource}) do
    %{
      resource: %{
        id: resource.id,
        url: resource.url,
        created_at: resource.inserted_at,
        updated_at: resource.updated_at
      }
    }
  end

  def render("error.json", %{changeset: changeset}) do
    %{
      errors: Enum.map(changeset.errors, fn {attribute, message} ->
        %{
          attribute: attribute,
          message: translate_error(message)
        }
      end)
    }
  end
end
