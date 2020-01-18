defmodule Kamleague.Repo do
  use Ecto.Repo,
    otp_app: :kamleague,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 20
end
