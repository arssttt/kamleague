defmodule Kamleague.Leagues.Map do
  use Ecto.Schema
  import Ecto.Changeset

  schema "maps" do
    field :locations, :integer
    field :name, :string

    has_many :games, Kamleague.Leagues.Game
    timestamps()
  end

  @doc false
  def changeset(map, attrs) do
    map
    |> cast(attrs, [:name, :locations])
    |> validate_required([:name, :locations])
    |> unique_constraint(:name)
  end
end
