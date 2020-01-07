defmodule Kamleague.Leagues.TeamsGamesPlayers do
  use Ecto.Schema

  import Ecto.Changeset

  schema "teams_games_players" do
    belongs_to :teams_games, Kamleague.Leagues.TeamsGames
    field :location, :integer
    field :approved, :boolean, default: false

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:location, :approved])
    |> validate_required([:location, :approved])
  end

  def changeset_approve(changeset, params) do
    changeset
    |> cast(params, [:approved])
  end
end
