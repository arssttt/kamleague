defmodule Kamleague.Repo.Migrations.AddPlayedAtToGames do
  use Ecto.Migration

  def change do
    alter table(:games) do
      add :played_at, :utc_datetime
    end
  end
end
