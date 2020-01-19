defmodule KamleagueWeb.GameController do
  use KamleagueWeb, :controller

  alias Kamleague.Leagues
  alias Kamleague.Leagues.Game

  def new(conn, %{"map_id" => map_id}) do
    map = Leagues.get_map!(map_id)

    players =
      Enum.reject(Leagues.list_active_players(), fn player ->
        player.id == Pow.Plug.current_user(conn).player.id
      end)

    teams = Leagues.list_teams()

    changeset = Leagues.change_game(%Game{})

    render(conn, "new.html",
      changeset: changeset,
      map: map,
      players: players,
      teams: teams,
      error: ""
    )
  end

  def create(conn, %{"game" => game_params, "map_id" => map_id}) do
    # Add the current user id to the first player
    game_params =
      game_params
      |> put_in(["players", "1", "player_id"], Pow.Plug.current_user(conn).player.id)
      |> put_in(["players", "1", "approved"], true)

    map = Leagues.get_map!(map_id)
    changeset = Leagues.change_game(%Game{})

    players =
      Enum.reject(Leagues.list_active_players(), fn player ->
        player.id == Pow.Plug.current_user(conn).player.id
      end)

    if is_nil(game_params["winner_id"]) || game_params["players"]["2"]["player_id"] == "" do
      error = "Please fill in everything."
      render(conn, "new.html", changeset: changeset, map: map, players: players, error: error)
    end

    case Leagues.create_game(map, game_params) do
      {:ok, _game} ->
        conn
        |> put_flash(:info, "Game created successfully.")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
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

  def update(conn, %{"id" => id, "approved" => approved}) do
    game = Leagues.get_game!(id)

    case Leagues.approve_game(game, approved, Pow.Plug.current_user(conn).player.id) do
      {:ok, _game} ->
        Leagues.calculate_elo()

        conn
        |> put_flash(:info, "Map updated successfully.")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    game = Leagues.get_game!(id)

    {:ok, _game} = Leagues.delete_game(game)
    Kamleague.Leagues.calculate_elo()

    conn
    |> put_flash(:info, "Game deleted successfully.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
