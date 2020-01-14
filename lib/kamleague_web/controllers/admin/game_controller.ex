defmodule KamleagueWeb.Admin.GameController do
  use KamleagueWeb, :controller

  alias Kamleague.Leagues

  def index(conn, _params) do
    games = Leagues.list_all_games()
    render(conn, "index.html", games: games)
  end

  def delete(conn, %{"id" => id}) do
    game = Leagues.get_game!(id)
    {:ok, _game} = Leagues.delete_game(game)
    Leagues.calculate_elo()

    conn
    |> put_flash(:info, "Game deleted successfully.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
