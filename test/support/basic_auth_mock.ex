defmodule Inbox.BasicAuthMock do
  use Phoenix.ConnTest

  @username Application.get_env(:inbox, :basic_auth)[:username]
  @password Application.get_env(:inbox, :basic_auth)[:password]

  def with_valid_auth(conn, username \\ @username, password \\ @password) do
    header_content = "Basic " <> Base.encode64("#{username}:#{password}")
    conn |> put_req_header("authorization", header_content)
  end
end
