defmodule Kamleague.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :map_id, references(:maps, on_delete: :nothing)

      timestamps()
    end

    create index(:games, [:map_id])
  end
end
