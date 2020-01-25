defmodule KamleagueWeb.StatisticsController do
  use KamleagueWeb, :controller

  def games(conn, params) do
    page = Kamleague.Leagues.list_games(params)

    render(conn, "games.html",
      games: page.entries,
      page: page
    )
  end
end
