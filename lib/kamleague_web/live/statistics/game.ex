defmodule KamleagueWeb.StatisticsLive.Games do
  use Phoenix.LiveView

  alias Kamleague.Leagues
  alias KamleagueWeb.StatisticsView

  def render(assigns), do: StatisticsView.render("games.html", assigns)

  def mount(_session, socket) do
    {:ok, assign(socket, page: 1, per_page: 20, game: nil)}
  end

  def handle_params(params, _url, socket) do
    {page, ""} = Integer.parse(params["page"] || "1")
    {:noreply, socket |> assign(page: page) |> fetch()}
  end

  defp fetch(socket) do
    %{page: page, per_page: per_page} = socket.assigns
    assign(socket, games: Leagues.list_games(page, per_page))
  end

  def handle_event("select_game", %{"id" => id}, socket) do
    {:noreply, socket |> assign(game: Leagues.get_game!(id))}
  end
end
