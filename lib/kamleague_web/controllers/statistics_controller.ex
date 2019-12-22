defmodule KamleagueWeb.StatisticsController do
  use KamleagueWeb, :controller

  def games(conn, _params) do
    games = Kamleague.Leagues.list_games()
    render(conn, "games.html", games: games)
  end
end
