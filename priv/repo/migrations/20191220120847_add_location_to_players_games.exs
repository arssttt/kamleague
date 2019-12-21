defmodule Kamleague.Repo.Migrations.AddLocationToPlayersGames do
  use Ecto.Migration

  def change do
    alter table(:players_games) do
      add :location, :integer, null: false
    end
  end
end
