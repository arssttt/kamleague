defmodule Kamleague.Repo.Migrations.RenameTeamGamesIdColumn do
  use Ecto.Migration

  def change do
    rename table("teams_games_players"), :team_game_id, to: :teams_games_id
  end
end
