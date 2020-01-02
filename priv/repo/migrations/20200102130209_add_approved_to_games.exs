defmodule Kamleague.Repo.Migrations.AddApprovedToGames do
  use Ecto.Migration

  def change do
    alter table(:games) do
      add :approved, :boolean, default: false
    end
  end
end
