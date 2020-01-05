defmodule KamleagueWeb.PageController do
  use KamleagueWeb, :controller

  def index(conn, _params) do
    players = Kamleague.Leagues.list_active_players()
    teams = Kamleague.Leagues.list_teams()
    render(conn, "index.html", players: players, teams: teams)
  end

  def rules(conn, _params) do
    # Fetch post with the tag rules since only one post is allowed to have the "rules" tag
    post = Kamleague.Contents.get_post_by_tag!("Rules")
    render(conn, "rules.html", post: post)
  end
end
