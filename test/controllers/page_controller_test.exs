defmodule Inbox.PageControllerTest do
  use Inbox.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Hello, Inbox!"
  end
end
