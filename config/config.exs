# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :inbox,
  ecto_repos: [Inbox.Repo]

# Configures the endpoint
config :inbox, Inbox.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "RINSS3AKAazIQWJncNDan4XHNvwMqPgAzvzkwPbicX4UAGGnEIeN05sGX59sbEUo",
  render_errors: [view: Inbox.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Inbox.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures basic auth
config :inbox, basic_auth: [
  username: {:system, "BASIC_AUTH_USERNAME"},
  password: {:system, "BASIC_AUTH_PASSWORD"},
  realm:    "Inbox"
]

config :mime, :types, %{
  "application/json" => ["json"],
  "text/plain" => ["text"],
}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
