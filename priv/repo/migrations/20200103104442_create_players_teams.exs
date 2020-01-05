defmodule Kamleague.Repo.Migrations.CreatePlayersTeams do
  use Ecto.Migration

  def change do
    create table(:players_teams) do
      add(:player_id, references(:players, on_delete: :nothing))
      add(:team_id, references(:teams, on_delete: :delete_all))
      timestamps()
    end

    create(
      unique_index(:players_teams, [:player_id, :team_id], name: :player_id_team_id_unique_index)
    )
  end
end
