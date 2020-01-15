defmodule KamleagueWeb.Admin.UserController do
  use KamleagueWeb, :controller

  alias Kamleague.Accounts
  alias Kamleague.Accounts.CountryCodes

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    country_codes = CountryCodes.list_country_codes()
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset, country_codes: country_codes)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Kamleague.Accounts.get_user!(id)
    user_params = Map.put(user_params, "id", id)
    country_codes = CountryCodes.list_country_codes()

    case Accounts.update_user(user, user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.admin_user_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset, country_codes: country_codes)
    end
  end

  @spec delete(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    case Accounts.lock(user) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User locked successfully.")
        |> redirect(to: Routes.admin_user_path(conn, :index))

      {:error, _changeset} ->
        conn
        |> redirect(to: Routes.admin_user_path(conn, :index))
    end
  end
end
