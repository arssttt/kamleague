defmodule Kamleague.Leagues.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    belongs_to :map, Kamleague.Leagues.Map
    has_many :players_games, Kamleague.Leagues.PlayersGames
    has_many :players, through: [:players_games, :player]

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [])
    |> validate_required([])
  end
end
