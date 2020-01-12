defmodule KamleagueWeb.Admin.UserController do
  use KamleagueWeb, :controller

  alias Kamleague.Accounts

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end
end
