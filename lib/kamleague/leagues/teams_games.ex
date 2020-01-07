defmodule Kamleague.Leagues.TeamsGames do
  use Ecto.Schema

  import Ecto.Changeset

  schema "teams_games" do
    belongs_to :team, Kamleague.Leagues.Team, foreign_key: :team_id
    belongs_to :game, Kamleague.Leagues.Game, foreign_key: :game_id
    has_many :players, Kamleague.Leagues.PlayersTeamsGames
    field :win, :boolean
    field :old_elo, :integer
    field :new_elo, :integer
    field :approved, :boolean, default: false

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :team_id,
      :game_id,
      :win,
      :old_elo,
      :new_elo,
      :approved
    ])
    |> validate_required([:player_id, :game_id, :win, :old_elo, :new_elo])
  end

  def changeset_approve(changeset, params) do
    changeset
    |> cast(params, [:approved])
  end
end
