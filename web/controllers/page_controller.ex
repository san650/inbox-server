defmodule Inbox.PageController do
  use Inbox.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
