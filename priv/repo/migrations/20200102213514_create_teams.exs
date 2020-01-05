defmodule Kamleague.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string
      add :owner_id, references(:players, on_delete: :nothing)

      timestamps()
    end

    create index(:teams, [:owner_id])

    create unique_index(:teams, [:name])
  end
end
