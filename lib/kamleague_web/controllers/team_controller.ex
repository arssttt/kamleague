defmodule KamleagueWeb.TeamController do
  use KamleagueWeb, :controller

  alias Kamleague.Leagues
  alias Kamleague.Leagues.Team

  plug :check_amount_of_teams when action in [:new, :create, :update]

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
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        players =
          Enum.reject(Leagues.list_players(), fn player ->
            player.id == Pow.Plug.current_user(conn).player.id
          end)

        render(conn, "new.html", changeset: changeset, players: players)
    end
  end

  def show(conn, %{"slug" => slug}) do
    team = Leagues.get_team_by_slug!(slug)
    games = Leagues.list_games_team(team)
    render(conn, "show.html", team: team, games: games)
  end

  def update(conn, %{"id" => id}) do
    team = Leagues.get_team!(id)

    case Leagues.approve_team(team) do
      {:ok, _team} ->
        conn
        |> put_flash(:info, "Team updated successfully.")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", team: team, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    team = Leagues.get_team!(id)
    {:ok, _team} = Leagues.delete_team(team)

    conn
    |> put_flash(:info, "Team deleted successfully.")
    |> redirect(to: Routes.page_path(conn, :index))
  end

  defp check_amount_of_teams(conn, _opts) do
    if length(Pow.Plug.current_user(conn).player.teams) >= 2 do
      conn
      |> put_flash(:info, "You have already reached the maximum amount of teams allowed.")
      |> redirect(to: Routes.page_path(conn, :index))
    else
      conn
    end
  end
end
