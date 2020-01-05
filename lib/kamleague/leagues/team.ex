defmodule Kamleague.Leagues.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    belongs_to :owner, Kamleague.Leagues.Player
    has_many :players, Kamleague.Leagues.PlayersTeams

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
