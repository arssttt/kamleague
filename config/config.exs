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
  pubsub: [name: Kamleague.PubSub, adapter: Phoenix.PubSub.PG2],
  static_url: [scheme: "https", host: "di4uyngxcqrr1.cloudfront.net/assets", port: 443]

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
  web_module: KamleagueWeb,
  mailer_backend: KamleagueWeb.PowMailer,
  extensions: [PowResetPassword],
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks

# Configures Arc
config :arc,
  bucket: "kamleague",
  virtual_host: true

# Configures Arc AWS
config :ex_aws,
  json_codec: Jason,
  access_key_id: System.get_env("ACCESS_KEY_ID"),
  secret_access_key: System.get_env("SECRET_ACCESS_KEY"),
  region: "eu-central-1",
  s3: [
    scheme: "https://",
    host: "s3.eu-central-1.amazonaws.com",
    region: "eu-central-1"
  ]

# Configures Quantum
config :kamleague, Kamleague.Scheduler,
  jobs: [
    {"@daily", {Kamleague.Leagues, :check_inactive, []}}
  ]

# Configures Scrivener
config :scrivener_html,
  routes_helper: Kamleague.Router.Helpers

# Configures Bamboo
config :kamleague, KamleagueWeb.PowMailer,
  adapter: Bamboo.SMTPAdapter,
  server: "mail.privateemail.com",
  hostname: "kamleague.com",
  port: 465,
  username: System.get_env("SMTP_USERNAME"),
  password: System.get_env("SMTP_PASSWORD"),
  tls: :never,
  ssl: true,
  retries: 10

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
