defmodule KamleagueWeb.MapController do
  use KamleagueWeb, :controller

  alias Kamleague.Leagues
  alias Kamleague.Leagues.Map

  def index(conn, _params) do
    maps = Leagues.list_maps()
    render(conn, "index.html", maps: maps)
  end

  def show(conn, %{"id" => id}) do
    map = Leagues.get_map!(id)
    render(conn, "show.html", map: map)
  end
end
