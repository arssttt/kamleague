defmodule KamleagueWeb.AssignUser do
  import Plug.Conn

  alias Kamleague.Accounts.User
  alias Kamleague.Leagues
  alias Kamleague.Repo

  @spec init(any) :: any
  def init(opts), do: opts

  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  def call(conn, _params) do
    case Pow.Plug.current_user(conn) do
      %User{} = user ->
        conn
        |> assign(
          :current_user,
          Repo.preload(user, player: [:games, [teams: [team: [players: :player_info]]]])
        )
        |> assign(:unapproved_games, Leagues.list_unapproved_games(Leagues.get_player!(user)))
        |> assign(
          :unapproved_team_games,
          Leagues.list_unapproved_team_games(Leagues.get_player!(user))
        )
        |> assign(:unapproved_teams, Leagues.list_unapproved_teams(Leagues.get_player!(user)))
        |> assign(:maps, Kamleague.Leagues.list_maps())

      _ ->
        assign(conn, :current_user, nil)
    end
  end
end
