defmodule KamleagueWeb.PlayerController do
  use KamleagueWeb, :controller

  alias Kamleague.Leagues

  def show(conn, %{"slug" => slug}) do
    player = Leagues.get_player_by_slug(slug)
    games = Leagues.list_player_games(player)
    render(conn, "show.html", player: player, games: games)
  end

  def update(conn, params) do
    player = Pow.Plug.current_user(conn).player

    case Leagues.set_active(player, params) do
      {:ok, _player} ->
        conn
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _changeset} ->
        render(conn, "index.html")
    end
  end
end
