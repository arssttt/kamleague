defmodule Kamleague.Leagues.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    field :elo, :integer, default: 1000
    field :wins, :integer, default: 0
    field :losses, :integer, default: 0
    field :slug, :string
    field :approved, :boolean, default: false
    belongs_to :owner, Kamleague.Leagues.Player
    has_many :players, Kamleague.Leagues.PlayersTeams

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    # Merge the slug with attrs
    attrs = Map.merge(attrs, slugify_name(attrs))

    team
    |> cast(attrs, [:name, :slug])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

  def changeset_game(team_or_changeset, attrs) do
    team_or_changeset
    |> Ecto.Changeset.cast(attrs, [:elo, :wins, :losses])
  end

  def changeset_approve(team_or_changeset) do
    changeset = Ecto.Changeset.change(team_or_changeset)

    case changeset do
      %{data: %{approved: false}} -> Ecto.Changeset.change(changeset, approved: true)
      changeset -> changeset
    end
  end

  # Transform name into our slug
  defp slugify_name(%{"name" => name}) do
    slug =
      name
      |> String.downcase()
      |> String.replace(~r/[^a-z0-9\s-]/, "")
      |> String.replace(~r/(\s|-)+/, "")

    %{"slug" => slug}
  end

  # Need to have a function w/o name for our :new controller method
  defp slugify_name(_params) do
    %{}
  end
end
