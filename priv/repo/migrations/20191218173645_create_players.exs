defmodule Kamleague.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :nickname, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :elo, :integer, default: 1000
      add :active, :boolean, default: false

      timestamps()
    end

    create unique_index(:players, [:nickname])
    create index(:players, [:user_id])
  end
end
