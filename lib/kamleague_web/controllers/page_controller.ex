defmodule KamleagueWeb.PageController do
  use KamleagueWeb, :controller

  def index(conn, _params) do
    players = Kamleague.Leagues.list_active_players()
    teams = Kamleague.Leagues.list_teams()
    render(conn, "index.html", players: players, teams: teams)
  end

  def rules(conn, _params) do
    rules = Kamleague.Contents.get_post_by_tag!("Rules")
    map_list = Kamleague.Contents.get_post_by_tag!("Maplist")
    render(conn, "rules.html", rules: rules, map_list: map_list)
  end
end
