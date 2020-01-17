defmodule Kamleague.Leagues.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    belongs_to :map, Kamleague.Leagues.Map
    has_many :players, Kamleague.Leagues.PlayersGames
    has_many :teams, Kamleague.Leagues.TeamsGames
    field :played_at, :utc_datetime
    field :k_factor, :integer
    field :deleted, :boolean, default: false
    field :approved, :boolean, default: false
    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:played_at])
    |> validate_required([:played_at])
    |> validate_current_or_past_date(:played_at)
  end

  def changeset_update(game_or_changset, attrs) do
    game_or_changset
    |> cast(attrs, [:deleted, :approved])
  end

  def changeset_k_factor(game_or_changset, attrs) do
    game_or_changset
    |> cast(attrs, [:k_factor])
    |> validate_required([:k_factor])
  end

  def changeset_approve(game_or_changeset) do
    changeset = Ecto.Changeset.change(game_or_changeset)

    case changeset do
      %{data: %{approved: false}} -> Ecto.Changeset.change(changeset, approved: true)
      changeset -> changeset
    end
  end

  def changeset_delete(game_or_changeset) do
    changeset = Ecto.Changeset.change(game_or_changeset)

    case changeset do
      %{data: %{deleted: false}} -> Ecto.Changeset.change(changeset, deleted: true)
      changeset -> changeset
    end
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
