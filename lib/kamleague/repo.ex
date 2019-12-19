defmodule Kamleague.Repo do
  use Ecto.Repo,
    otp_app: :kamleague,
    adapter: Ecto.Adapters.Postgres
end
