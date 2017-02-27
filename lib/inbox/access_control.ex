defmodule Inbox.AccessControl do
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, _opts) do
    conn
    |> put_resp_header("Access-Control-Allow-Origin", Application.get_env(:inbox, :allow_origin))
  end
end
