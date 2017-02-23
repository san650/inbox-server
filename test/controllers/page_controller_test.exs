defmodule Inbox.PageControllerTest do
  use Inbox.ConnCase

  test "GET /", %{conn: conn} do
    response = conn
               |> with_valid_auth
               |> get("/")
               |> html_response(200)

    assert response =~ "Hello, Inbox!"
  end
end
