defmodule Kamleague.Leagues.PlayersTeams do
  use Ecto.Schema

  import Ecto.Changeset

  schema "players_teams" do
    belongs_to :player_info, Kamleague.Leagues.Player, foreign_key: :player_id
    belongs_to :team, Kamleague.Leagues.Team
    field :joined, :boolean, default: false

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:player_id, :team_id])
    |> validate_required([:player_id, :team_id])
  end

  def changeset_join(changeset, params) do
    changeset
    |> cast(params, [:joined])
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
