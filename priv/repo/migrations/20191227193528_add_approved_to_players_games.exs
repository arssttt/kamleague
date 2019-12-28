defmodule Kamleague.Repo.Migrations.AddApprovedToPlayersGames do
  use Ecto.Migration

  def change do
    alter table(:players_games) do
      add :approved, :boolean, default: false
    end
  end
end
