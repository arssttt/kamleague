defmodule Kamleague.Repo.Migrations.AddWinToPlayersGames do
  use Ecto.Migration

  def change do
    alter table(:players_games) do
      add :win, :boolean, null: false
    end
  end
end
