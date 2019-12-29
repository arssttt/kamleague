defmodule Kamleague.Leagues.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    belongs_to :map, Kamleague.Leagues.Map
    has_many :players, Kamleague.Leagues.PlayersGames
    field :played_at, :utc_datetime
    field :deleted, :boolean, default: false
    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:played_at])
    |> validate_required([:played_at])
    |> validate_current_or_past_date(:played_at)
  end

  def validate_current_or_past_date(%{changes: changes} = changeset, field) do
    if date = changes[field] do
      do_validate_current_or_past_date(changeset, field, date)
    else
      changeset
    end
  end

  defp do_validate_current_or_past_date(changeset, field, date) do
    today = DateTime.utc_now()

    if Date.compare(date, today) == :gt do
      changeset
      |> add_error(field, "Add a valid date")
    else
      changeset
    end
  end
end
