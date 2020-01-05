defmodule Kamleague.Leagues.PlayersTeams do
  use Ecto.Schema

  import Ecto.Changeset

  schema "players_teams" do
    belongs_to :player, Kamleague.Leagues.Player
    belongs_to :team, Kamleague.Leagues.Team

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:player_id, :team_id])
    |> validate_required([:player_id, :team_id])
  end
end
