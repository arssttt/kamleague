defmodule Kamleague.Leagues.Map do
  use Ecto.Schema
  import Ecto.Changeset

  schema "maps" do
    field :locations, :integer
    field :name, :string
    field :slug, :string

    has_many :games, Kamleague.Leagues.Game
    timestamps()
  end

  @doc false
  def changeset(map, attrs) do
    map
    |> cast(attrs, [:name, :locations, :slug])
    |> validate_required([:name, :locations, :slug])
    |> unique_constraint(:name)
    |> unique_constraint(:slug)
  end
end
