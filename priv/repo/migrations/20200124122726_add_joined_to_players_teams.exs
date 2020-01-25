defmodule Kamleague.Repo.Migrations.AddJoinedToPlayersTeams do
  use Ecto.Migration

  def change do
    alter table(:players_teams) do
      add :joined, :boolean, default: false
    end
  end
end
