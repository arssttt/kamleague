defmodule Kamleague.Repo.Migrations.AddEloWinsLossesToTeams do
  use Ecto.Migration

  def change do
    alter table(:teams) do
      add :elo, :integer, default: 1000
      add :wins, :integer, default: 0
      add :losses, :integer, default: 0
    end
  end
end
