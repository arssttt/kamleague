defmodule Kamleague.Leagues.Player do
  use Ecto.Schema
  import Ecto.Changeset

  schema "players" do
    field :nickname, :string
    field :elo, :integer, default: 1000
    field :active, :boolean, default: false
    field :wins, :integer, default: 0
    field :losses, :integer, default: 0
    belongs_to :user, Kamleague.Accounts.User
    has_many :games, Kamleague.Leagues.PlayersGames
    has_many :teams, Kamleague.Leagues.PlayersTeams

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:nickname, :active])
    |> validate_required([:nickname])
    |> unique_constraint(:nickname)
  end

  def changeset_game(player_or_changeset, attrs) do
    player_or_changeset
    |> Ecto.Changeset.cast(attrs, [:elo, :wins, :losses])
  end

  def changeset_active(player_or_changeset, attrs) do
    player_or_changeset
    |> Ecto.Changeset.cast(attrs, [:active])
  end
end
