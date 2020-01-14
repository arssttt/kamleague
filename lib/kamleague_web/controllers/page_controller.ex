defmodule KamleagueWeb.PageController do
  use KamleagueWeb, :controller

  def index(conn, _params) do
    players = Kamleague.Leagues.list_active_players()
    teams = Kamleague.Leagues.list_teams()
    render(conn, "index.html", players: players, teams: teams)
  end

  def howtoplay(conn, _params) do
    post = Kamleague.Contents.get_post_by_tag!("how-to-play")
    render(conn, "how_to_play.html", post: post)
  end

  def rules(conn, _params) do
    post = Kamleague.Contents.get_post_by_tag!("Rules")
    map_list = Kamleague.Contents.get_post_by_tag!("Maplist")
    render(conn, "rules.html", post: post, map_list: map_list)
  end

  def faq(conn, _params) do
    post = Kamleague.Contents.get_post_by_tag!("FAQ")
    render(conn, "faq.html", post: post)
  end

  def news(conn, _params) do
    posts = Kamleague.Contents.list_posts("News")
    render(conn, "news.html", posts: posts)
  end
end
