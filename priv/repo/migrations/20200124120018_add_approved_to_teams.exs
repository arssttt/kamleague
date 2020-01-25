defmodule Kamleague.Repo.Migrations.AddApprovedToTeams do
  use Ecto.Migration

  def change do
    alter table(:teams) do
      add :approved, :boolean, default: false
    end
  end
end
