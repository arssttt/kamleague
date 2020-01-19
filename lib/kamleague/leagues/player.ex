defmodule Kamleague.Leagues.Player do
  use Ecto.Schema
  import Ecto.Changeset

  schema "players" do
    field :nickname, :string
    field :elo, :integer, default: 1000
    field :active, :boolean, default: false
    field :wins, :integer, default: 0
    field :losses, :integer, default: 0
    field :slug, :string
    belongs_to :user, Kamleague.Accounts.User
    has_many :games, Kamleague.Leagues.PlayersGames
    has_many :teams, Kamleague.Leagues.PlayersTeams

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    # Merge the slug with attrs
    attrs = Map.merge(attrs, slugify_nickname(attrs))

    player
    |> cast(attrs, [:nickname, :active, :slug])
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

  # Transform nickname into our slug
  defp slugify_nickname(%{"nickname" => nickname}) do
    slug =
      nickname
      |> String.downcase()
      |> String.replace(~r/[^a-z0-9\s-]/, "")
      |> String.replace(~r/(\s|-)+/, "")

    %{"slug" => slug}
  end

  # Need to have a function w/o nickname for our :new controller method
  defp slugify_nickname(_params) do
    %{}
  end
end
