defmodule Kamleague.Repo.Migrations.AddSlugToMaps do
  use Ecto.Migration

  def change do
    alter table(:maps) do
      add :slug, :string
    end

    create unique_index(:maps, [:slug])
  end
end
