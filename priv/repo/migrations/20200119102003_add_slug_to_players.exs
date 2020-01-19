defmodule Kamleague.Repo.Migrations.AddSlugToPlayers do
  use Ecto.Migration

  def change do
    alter table(:players) do
      add :slug, :string
    end

    create unique_index(:players, [:slug])
  end
end
