defmodule Kamleague.Repo.Migrations.AddTypeToGames do
  use Ecto.Migration

  def change do
    alter table(:games) do
      add :type, :string
    end
  end
end
