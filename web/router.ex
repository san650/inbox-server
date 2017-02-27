defmodule Inbox.Router do
  use Inbox.Web, :router

  pipeline :auth do
    plug Inbox.AccessControl
    plug BasicAuth, use_config: {:inbox, :basic_auth}
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json", "txt"]
  end

  scope "/", Inbox do
    pipe_through [:auth, :browser]

    get "/", PageController, :index
  end

  scope "/api/v1", Inbox do
    pipe_through [:auth, :api]
    resources "/resources", ResourceController
    resources "/tags", TagController, only: [:index]
  end
end
