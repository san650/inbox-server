defmodule Inbox.TagView do
  use Inbox.Web, :view

  def render("index.json", %{tags: tags}) do
    %{data: render_many(tags, Inbox.TagView, "tag.json")}
  end

  def render("tag.json", %{tag: tag}) do
    %{name: tag.name,
      group: tag.group,
      system: tag.system}
  end
end
