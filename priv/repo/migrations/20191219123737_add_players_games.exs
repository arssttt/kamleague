defmodule Kamleague.Repo.Migrations.AddPlayersGames do
  use Ecto.Migration

  def change do
    create table(:players_games, primary_key: false) do
      add(:player_id, references(:players, on_delete: :delete_all), primary_key: true)
      add(:game_id, references(:games, on_delete: :delete_all), primary_key: true)
      timestamps()
    end

    create(index(:players_games, [:player_id]))
    create(index(:players_games, [:game_id]))

    create(
      unique_index(:players_games, [:player_id, :game_id], name: :player_id_game_id_unique_index)
    )
  end
end
