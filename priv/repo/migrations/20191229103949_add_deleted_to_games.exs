defmodule Kamleague.Repo.Migrations.AddDeletedToGames do
  use Ecto.Migration

  def change do
    alter table(:games) do
      add :deleted, :boolean, default: false
    end
  end
end
