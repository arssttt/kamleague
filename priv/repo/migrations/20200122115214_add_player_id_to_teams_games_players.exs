defmodule Kamleague.Repo.Migrations.AddPlayerIdToTeamsGamesPlayers do
  use Ecto.Migration

  def change do
    alter table(:teams_games_players) do
      add(:player_id, references(:players, on_delete: :delete_all))
    end
  end
end
