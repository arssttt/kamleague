defmodule KamleagueWeb.GameController do
  use KamleagueWeb, :controller

  alias Kamleague.Leagues
  alias Kamleague.Leagues.Game

  def index(conn, _params) do
    games = Leagues.list_games()
    render(conn, "index.html", games: games)
  end

  def new(conn, _params) do
    players = Leagues.list_active_players()
    changeset = Leagues.change_game(%Game{})
    render(conn, "new.html", changeset: changeset, players: players)
  end

  def create(conn, %{"game" => game_params}) do
    case Leagues.create_game(game_params) do
      {:ok, _game} ->
        conn
        |> put_flash(:info, "Game created successfully.")
        |> redirect(to: Routes.game_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    game = Leagues.get_game!(id)
    render(conn, "show.html", game: game)
  end

  def edit(conn, %{"id" => id}) do
    game = Leagues.get_game!(id)
    changeset = Leagues.change_game(game)
    render(conn, "edit.html", game: game, changeset: changeset)
  end

  def update(conn, %{"id" => id, "map" => map_params}) do
    map = Leagues.get_map!(id)

    case Leagues.update_map(map, map_params) do
      {:ok, map} ->
        conn
        |> put_flash(:info, "Map updated successfully.")
        |> redirect(to: Routes.game_path(conn, :show, map))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", map: map, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    map = Leagues.get_map!(id)
    {:ok, _map} = Leagues.delete_map(map)

    conn
    |> put_flash(:info, "Map deleted successfully.")
    |> redirect(to: Routes.map_path(conn, :new))
  end
end
