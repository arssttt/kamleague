defmodule KamleagueWeb.RegistrationController do
  use KamleagueWeb, :controller

  alias Kamleague.Accounts.CountryCodes

  def new(conn, _params) do
    country_codes = CountryCodes.list_country_codes()
    changeset = Pow.Plug.change_user(conn)

    render(conn, "new.html", changeset: changeset, country_codes: country_codes)
  end

  def create(conn, %{"user" => user_params}) do
    conn
    |> Pow.Plug.create_user(user_params)
    |> case do
      {:ok, _user, conn} ->
        Kamleague.Accounts.update_user_ip(conn)

        conn
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, changeset, conn} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
