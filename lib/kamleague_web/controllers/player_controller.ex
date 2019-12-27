defmodule KamleagueWeb.PlayerController do
  use KamleagueWeb, :controller

  alias Kamleague.Leagues

  def update(conn, params) do
    player = Pow.Plug.current_user(conn).player

    case Leagues.set_active(player, params) do
      {:ok, _player} ->
        conn
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _changeset} ->
        render(conn, "index.html")
    end
  end
end
