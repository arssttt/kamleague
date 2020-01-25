defmodule Kamleague.Repo.Migrations.AddOldNewWinsLossesToTeamsGames do
  use Ecto.Migration

  def change do
    alter table(:teams_games) do
      add :old_wins, :integer
      add :new_wins, :integer
      add :old_losses, :integer
      add :new_losses, :integer
    end
  end
end
