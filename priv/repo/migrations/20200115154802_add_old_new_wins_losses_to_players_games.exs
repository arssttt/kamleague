defmodule Kamleague.Repo.Migrations.AddOldNewWinsLossesToPlayersGames do
  use Ecto.Migration

  def change do
    alter table(:players_games) do
      add :old_wins, :integer
      add :new_wins, :integer
      add :old_losses, :integer
      add :new_losses, :integer
    end
  end
end
