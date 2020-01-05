defmodule KamleagueWeb.TeamController do
  use KamleagueWeb, :controller

  alias Kamleague.Leagues
  alias Kamleague.Leagues.Team

  def index(conn, _params) do
    teams = Leagues.list_teams()
    render(conn, "index.html", teams: teams)
  end

  def new(conn, _params) do
    players =
      Enum.reject(Leagues.list_players(), fn player ->
        player.id == Pow.Plug.current_user(conn).player.id
      end)

    changeset = Leagues.change_team(%Team{})
    render(conn, "new.html", changeset: changeset, players: players)
  end

  def create(conn, %{"team" => team_params}) do
    case Leagues.create_team(Pow.Plug.current_user(conn).player, team_params) do
      {:ok, _team} ->
        conn
        |> put_flash(:info, "Team created successfully.")
        |> redirect(to: Routes.team_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    team = Leagues.get_team!(id)
    render(conn, "show.html", team: team)
  end

  def edit(conn, %{"id" => id}) do
    team = Leagues.get_team!(id)
    changeset = Leagues.change_team(team)
    render(conn, "edit.html", team: team, changeset: changeset)
  end

  def update(conn, %{"id" => id, "team" => team_params}) do
    team = Leagues.get_team!(id)

    case Leagues.update_team(team, team_params) do
      {:ok, team} ->
        conn
        |> put_flash(:info, "Team updated successfully.")
        |> redirect(to: Routes.team_path(conn, :show, team))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", team: team, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    team = Leagues.get_team!(id)
    {:ok, _team} = Leagues.delete_team(team)

    conn
    |> put_flash(:info, "Team deleted successfully.")
    |> redirect(to: Routes.team_path(conn, :index))
  end
end
