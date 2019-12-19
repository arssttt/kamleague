defmodule Kamleague.Leagues.PlayersGames do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false
  schema "players_games" do
    belongs_to :player, Kamleague.Leagues.Player
    belongs_to :game, Kamleague.Leagues.Game

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:player_id, :game_id])
    |> validate_required([:player_id, :game_id])
  end
end
