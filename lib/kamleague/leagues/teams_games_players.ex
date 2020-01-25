defmodule Kamleague.Leagues.TeamsGamesPlayers do
  use Ecto.Schema

  import Ecto.Changeset

  schema "teams_games_players" do
    belongs_to :teams_games, Kamleague.Leagues.TeamsGames
    belongs_to :player, Kamleague.Leagues.Player
    field :location, :integer

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:location, :player_id])
    |> validate_required([:location, :player_id])
  end
end
