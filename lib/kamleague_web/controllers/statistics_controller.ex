defmodule KamleagueWeb.StatisticsController do
  use KamleagueWeb, :controller

  def games(conn, _params) do
    render(conn, "games.html")
  end
end
