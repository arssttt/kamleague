defmodule KamleagueWeb.PageController do
  use KamleagueWeb, :controller

  def index(conn, _params) do
    players = Kamleague.Leagues.list_active_players()
    render(conn, "index.html", players: players)
  end

  def rules(conn, _params) do
    post = Kamleague.Contents.get_post!(1)
    render(conn, "rules.html", post: post)
  end
end
