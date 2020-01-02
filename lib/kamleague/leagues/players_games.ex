defmodule Kamleague.Leagues.PlayersGames do
  use Ecto.Schema

  import Ecto.Changeset

  schema "players_games" do
    belongs_to :player_info, Kamleague.Leagues.Player, foreign_key: :player_id
    belongs_to :game, Kamleague.Leagues.Game, foreign_key: :game_id
    field :location, :integer
    field :win, :boolean
    field :old_elo, :integer
    field :new_elo, :integer
    field :approved, :boolean, default: false

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :player_id,
      :game_id,
      :location,
      :win,
      :old_elo,
      :new_elo,
      :approved
    ])
    |> validate_required([:player_id, :game_id, :location, :win, :old_elo, :new_elo])
  end

  def changeset_approve(changeset, params) do
    changeset
    |> cast(params, [:approved])
  end
end
