defmodule Kamleague.Repo.Migrations.CreateTeamsGamesPlayers do
  use Ecto.Migration

  def change do
    create table(:teams_games_players) do
      add(:team_game_id, references(:teams_games, on_delete: :delete_all))
      add :location, :integer
      add :approved, :boolean, default: false
      timestamps()
    end
  end
end
