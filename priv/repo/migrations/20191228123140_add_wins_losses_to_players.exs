defmodule Kamleague.Repo.Migrations.AddWinsLossesToPlayers do
  use Ecto.Migration

  def change do
    alter table(:players) do
      add :wins, :integer, default: 0
      add :losses, :integer, default: 0
    end
  end
end
