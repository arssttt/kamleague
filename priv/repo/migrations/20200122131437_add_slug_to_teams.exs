defmodule Kamleague.Repo.Migrations.AddSlugToTeams do
  use Ecto.Migration

  def change do
    alter table(:teams) do
      add :slug, :string
    end

    create unique_index(:teams, [:slug])
  end
end
