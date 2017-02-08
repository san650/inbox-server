defmodule Inbox.TagController do
  use Inbox.Web, :controller

  alias Inbox.Tag

  def index(conn, _params) do
    tags = Repo.all(Tag)
    render(conn, "index.json", tags: tags)
  end
end
