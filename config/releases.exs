# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
import Config

database_url =
  System.fetch_env!("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :kamleague, Kamleague.Repo,
  # ssl: true,
  url: database_url,
  pool_size: 10

secret_key_base =
  System.fetch_env!("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :kamleague, KamleagueWeb.Endpoint,
  url: [host: "www.kamleague.com", port: 80],
  http: [:inet6, port: 4000],
  secret_key_base: secret_key_base,
  server: true

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :kamleague, KamleagueWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
