defmodule KamleagueWeb.PageController do
  use KamleagueWeb, :controller

  def index(conn, _params) do
    players = Kamleague.Leagues.list_active_players()
    teams = Kamleague.Leagues.list_approved_teams()
    render(conn, "index.html", players: players, teams: teams)
  end

  def rules(conn, _params) do
    rules_solo = Kamleague.Contents.get_post_by_tag!("RulesSolo")
    rules_duo = Kamleague.Contents.get_post_by_tag!("RulesDuo")
    map_list_solo = Kamleague.Contents.get_post_by_tag!("MaplistSolo")
    map_list_duo = Kamleague.Contents.get_post_by_tag!("MaplistDuo")

    render(conn, "rules.html",
      rules_solo: rules_solo,
      rules_duo: rules_duo,
      map_list_solo: map_list_solo,
      map_list_duo: map_list_duo
    )
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
