defmodule Inbox.AccessControl do
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, _opts) do
    case Application.get_env(:inbox, :allow_origin) do
      nil -> conn
      value ->
        conn
        |> put_resp_header("Access-Control-Allow-Origin", value)
        |> put_resp_header("Access-Control-Allow-Credentials", "true")
    end
  end
end
