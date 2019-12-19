defmodule KamleagueWeb.MapController do
  use KamleagueWeb, :controller

  alias Kamleague.Leagues
  alias Kamleague.Leagues.Map

  def index(conn, _params) do
    maps = Leagues.list_maps()
    render(conn, "index.html", maps: maps)
  end

  def new(conn, _params) do
    maps = Leagues.list_maps()
    changeset = Leagues.change_map(%Map{})
    render(conn, "new.html", maps: maps, changeset: changeset)
  end

  def create(conn, %{"map" => map_params}) do
    maps = Leagues.list_maps()

    case Leagues.create_map(map_params) do
      {:ok, map} ->
        conn
        |> put_flash(:info, "Map created successfully.")
        |> redirect(to: Routes.map_path(conn, :show, map))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", maps: maps, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    map = Leagues.get_map!(id)
    render(conn, "show.html", map: map)
  end

  def edit(conn, %{"id" => id}) do
    map = Leagues.get_map!(id)
    changeset = Leagues.change_map(map)
    render(conn, "edit.html", map: map, changeset: changeset)
  end

  def update(conn, %{"id" => id, "map" => map_params}) do
    map = Leagues.get_map!(id)

    case Leagues.update_map(map, map_params) do
      {:ok, map} ->
        conn
        |> put_flash(:info, "Map updated successfully.")
        |> redirect(to: Routes.map_path(conn, :show, map))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", map: map, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    map = Leagues.get_map!(id)
    {:ok, _map} = Leagues.delete_map(map)

    conn
    |> put_flash(:info, "Map deleted successfully.")
    |> redirect(to: Routes.map_path(conn, :new))
  end
end
