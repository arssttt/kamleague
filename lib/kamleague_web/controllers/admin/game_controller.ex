defmodule KamleagueWeb.Admin.GameController do
  use KamleagueWeb, :controller

  alias Kamleague.Leagues

  def index(conn, _params) do
    games = Leagues.list_all_games()
    render(conn, "index.html", games: games)
  end

  def update(conn, %{"id" => id, "game" => game_params, "type" => type}) do
    game =
    case type do
      "2v2" -> Leagues.get_team_game!(id)
      "1v1" -> Leagues.get_game!(id)
    end
    case Leagues.update_game(game, game_params, type) do
      {:ok, _game} ->
        case type do
          "2v2" -> Leagues.calculate_team_elo()
          "1v1" -> Leagues.calculate_elo()
          _ -> Leagues.calculate_elo()
        end

        conn
        |> put_flash(:info, "Game updated successfully.")
        |> redirect(to: Routes.admin_game_path(conn, :index))

      {:error, _changeset} ->
        render(conn, "index.html", game: game)
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
    |> redirect(to: Routes.admin_game_path(conn, :index))
  end
end
