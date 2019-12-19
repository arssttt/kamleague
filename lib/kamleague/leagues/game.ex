defmodule Kamleague.Leagues.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :map_id, :id
    many_to_many(:players, Kamleague.Leagues.Player, join_through: Kamleague.Leagues.PlayersGames)

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [])
    |> validate_required([])
  end
end
