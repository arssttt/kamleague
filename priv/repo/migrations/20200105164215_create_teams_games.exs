defmodule Kamleague.Repo.Migrations.CreateTeamsGames do
  use Ecto.Migration

  def change do
    create table(:teams_games) do
      add(:team_id, references(:teams, on_delete: :delete_all))
      add(:game_id, references(:games, on_delete: :delete_all))
      add :win, :boolean
      add :old_elo, :integer
      add :new_elo, :integer
      add :approved, :boolean, default: false
      timestamps()
    end

    create(unique_index(:teams_games, [:team_id, :game_id], name: :team_id_game_id_unique_index))
  end
end
