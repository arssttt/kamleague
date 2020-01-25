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

    teams =
      Enum.reject(Leagues.list_approved_teams(), fn team ->
        Enum.find(Pow.Plug.current_user(conn).player.teams, fn t -> t.team.id == team.id end)
      end)

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

    teams =
      Enum.reject(Leagues.list_approved_teams(), fn team ->
        Enum.each(Pow.Plug.current_user(conn).player.teams, fn t ->
          team.id == t.id
        end)
      end)

    if is_nil(game_params["winner_id"]) || game_params["players"]["2"]["player_id"] == "" do
      error = "Please fill in everything."

      render(conn, "new.html",
        changeset: changeset,
        map: map,
        players: players,
        error: error,
        teams: teams
      )
    end

    case Leagues.create_game(map, game_params) do
      {:ok, _game} ->
        conn
        |> put_flash(:info, "Game created successfully.")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, map: map, players: players, teams: teams)
    end
  end

  def create_team(conn, %{"game" => game_params, "map_id" => map_id}) do
    game_params =
      game_params
      |> put_in(["teams", "1", "approved"], true)

    map = Leagues.get_map!(map_id)
    changeset = Leagues.change_game(%Game{})

    players =
      Enum.reject(Leagues.list_active_players(), fn player ->
        player.id == Pow.Plug.current_user(conn).player.id
      end)

    teams =
      Enum.reject(Leagues.list_approved_teams(), fn team ->
        Enum.each(Pow.Plug.current_user(conn).player.teams, fn t ->
          team.id == t.id
        end)
      end)

    if is_nil(game_params["winner_id"]) || game_params["teams"]["2"]["team_id"] == "" do
      error = "Please fill in everything."

      render(conn, "new.html",
        changeset: changeset,
        map: map,
        players: players,
        error: error,
        teams: teams
      )
    end

    case Leagues.create_team_game(map, game_params) do
      {:ok, _game} ->
        conn
        |> put_flash(:info, "Game created successfully.")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html",
          changeset: changeset,
          map: map,
          players: players,
          teams: teams,
          error: ""
        )
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

  def update(conn, %{"id" => id, "approved" => approved, "type" => type}) do
    game =
      case type do
        "2v2" -> Leagues.get_team_game!(id)
        "1v1" -> Leagues.get_game!(id)
      end

    case Leagues.approve_game(game, approved) do
      {:ok, _game} ->
        case type do
          "2v2" -> Leagues.calculate_team_elo()
          "1v1" -> Leagues.calculate_elo()
          _ -> Leagues.calculate_elo()
        end

        conn
        |> put_flash(:info, "Map updated successfully.")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    game = Leagues.get_game!(id)

    {:ok, game} = Leagues.delete_game(game)

    case game.type do
      "2v2" -> Leagues.calculate_team_elo()
      "1v1" -> Leagues.calculate_elo()
      _ -> Leagues.calculate_elo()
    end

    conn
    |> put_flash(:info, "Game deleted successfully.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
