defmodule KamleagueWeb.Admin.TeamController do
  use KamleagueWeb, :controller

  alias Kamleague.Leagues

  def index(conn, _params) do
    teams = Leagues.list_teams()
    render(conn, "index.html", teams: teams)
  end

  def edit(conn, %{"id" => id}) do
    team = Leagues.get_team!(id)
    changeset = Leagues.change_team(team)
    render(conn, "edit.html", team: team, changeset: changeset)
  end

  def update(conn, %{"id" => id, "team" => team_params}) do
    team = Leagues.get_team!(id)
    team_params = Map.put(team_params, "id", id)

    case Leagues.update_team(team, team_params) do
      {:ok, _team} ->
        conn
        |> put_flash(:info, "Team updated successfully.")
        |> redirect(to: Routes.admin_team_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", team: team, changeset: changeset)
    end
  end

  @spec delete(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def delete(conn, %{"id" => id}) do
    team = Leagues.get_team!(id)

    case Leagues.delete_team(team) do
      {:ok, _team} ->
        conn
        |> put_flash(:info, "Team deleted successfully.")
        |> redirect(to: Routes.admin_team_path(conn, :index))

      {:error, _changeset} ->
        conn
        |> redirect(to: Routes.admin_team_path(conn, :index))
    end
  end
end
