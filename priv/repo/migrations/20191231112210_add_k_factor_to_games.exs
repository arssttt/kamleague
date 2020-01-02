defmodule Kamleague.Repo.Migrations.AddKFactorToGames do
  use Ecto.Migration

  def change do
    alter table(:games) do
      add :k_factor, :integer
    end
  end
end
