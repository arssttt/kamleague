defmodule KamleagueWeb.StatisticsController do
  use KamleagueWeb, :controller

  def games(conn, _params) do
    games = Kamleague.Leagues.list_games(1, 20)
    render(conn, "games.html", games: games)
  end
end
