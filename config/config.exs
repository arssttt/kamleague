# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :kamleague,
  ecto_repos: [Kamleague.Repo]

# Configures the endpoint
config :kamleague, KamleagueWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "nF8lfhQpllrrwpoIM1DaKCZqmuQQOGVM10gc0sXJ3asRORjaGFTzVoHyW19YDeUa",
  render_errors: [view: KamleagueWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Kamleague.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configures Pow
config :kamleague, :pow,
  user: Kamleague.Accounts.User,
  repo: Kamleague.Repo,
  web_module: KamleagueWeb

# Configures Arc
config :arc,
  storage: Arc.Storage.Local

# Configures Quantum
config :kamleague, Kamleague.Scheduler,
  jobs: [
    {"@daily", {Kamleague.Leagues, :check_inactive, []}}
  ]

# Configures Scrivener
config :scrivener_html,
  routes_helper: Kamleague.Router.Helpers

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
