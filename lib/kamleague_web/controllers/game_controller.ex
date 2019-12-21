defmodule KamleagueWeb.GameController do
  use KamleagueWeb, :controller

  alias Kamleague.Leagues
  alias Kamleague.Leagues.Game

  def index(conn, _params) do
    games = Leagues.list_games()
    render(conn, "index.html", games: games)
  end

  def new(conn, %{"map_id" => map_id}) do
    map = Leagues.get_map!(map_id)

    players =
      Enum.reject(Leagues.list_active_players(), fn player ->
        player.id == Pow.Plug.current_user(conn).player.id
      end)

    changeset = Leagues.change_game(%Game{})
    render(conn, "new.html", changeset: changeset, map: map, players: players)
  end

  def create(conn, %{"game" => game_params, "map_id" => map_id}) do
    # Add the current user id to the first player
    game_params =
      put_in(game_params, ["players", "1", "player_id"], Pow.Plug.current_user(conn).player.id)

    map = Leagues.get_map!(map_id)

    case Leagues.create_game(map, game_params) do
      {:ok, _game} ->
        conn
        |> put_flash(:info, "Game created successfully.")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        players =
          Enum.reject(Leagues.list_active_players(), fn player ->
            player.id == Pow.Plug.current_user(conn).player.id
          end)

        render(conn, "new.html", changeset: changeset, map: map, players: players)
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
