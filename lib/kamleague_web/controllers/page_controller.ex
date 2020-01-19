defmodule KamleagueWeb.PageController do
  use KamleagueWeb, :controller

  def index(conn, _params) do
    players = Kamleague.Leagues.list_active_players()
    teams = Kamleague.Leagues.list_teams()
    render(conn, "index.html", players: players, teams: teams)
  end

  def rules(conn, _params) do
    post = Kamleague.Contents.get_post_by_tag!("Rules")
    map_list = Kamleague.Contents.get_post_by_tag!("Maplist")
    render(conn, "rules.html", post: post, map_list: map_list)
  end

  def elo(conn, _params) do
    post = Kamleague.Contents.get_post_by_tag!("Elo")
    render(conn, "elo.html", post: post)
  end

  def faq(conn, _params) do
    post = Kamleague.Contents.get_post_by_tag!("FAQ")
    render(conn, "faq.html", post: post)
  end

  def downloads(conn, _params) do
    post = Kamleague.Contents.get_post_by_tag!("Downloads")
    render(conn, "downloads.html", post: post)
  end

  def oldrankings(conn, _params) do
    post = Kamleague.Contents.get_post_by_tag!("Old")
    render(conn, "old_rankings.html", post: post)
  end
end
