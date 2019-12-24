defmodule Kamleague.Repo.Migrations.AddEloAndKfactorToPlayersGames do
  use Ecto.Migration

  def change do
    alter table(:players_games) do
      add :old_elo, :integer
      add :new_elo, :integer
      add :k_factor, :integer
    end
  end
end
