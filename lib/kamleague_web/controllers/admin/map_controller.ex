defmodule KamleagueWeb.Admin.MapController do
  use KamleagueWeb, :controller

  alias Kamleague.Leagues
  alias Kamleague.Leagues.Map

  def index(conn, _params) do
    maps = Leagues.list_maps()
    changeset = Leagues.change_map(%Map{})
    render(conn, "index.html", changeset: changeset, maps: maps)
  end

  def create(conn, %{"map" => map_params}) do
    maps = Leagues.list_maps()

    case Leagues.create_map(map_params) do
      {:ok, _map} ->
        conn
        |> put_flash(:info, "Map created successfully.")
        |> redirect(to: Routes.admin_map_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "index.html", changeset: changeset, maps: maps)
    end
  end

  def edit(conn, %{"id" => id}) do
    map = Leagues.get_map!(id)
    changeset = Leagues.change_map(map)
    render(conn, "edit.html", map: map, changeset: changeset)
  end

  def update(conn, %{"id" => id, "map" => map_params}) do
    map = Leagues.get_map!(id)

    case Leagues.update_map(map, map_params) do
      {:ok, _map} ->
        conn
        |> put_flash(:info, "Map updated successfully.")
        |> redirect(to: Routes.admin_map_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", map: map, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    map = Leagues.get_map!(id)
    {:ok, _map} = Leagues.delete_map(map)

    conn
    |> put_flash(:info, "Map deleted successfully.")
    |> redirect(to: Routes.admin_map_path(conn, :index))
  end
end
