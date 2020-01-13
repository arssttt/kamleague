defmodule KamleagueWeb.MapControllerTest do
  use KamleagueWeb.ConnCase

  alias Kamleague.Leagues

  @create_attrs %{locations: 42, name: "some name"}
  @update_attrs %{locations: 43, name: "some updated name"}
  @invalid_attrs %{locations: nil, name: nil}

  """
  TODO FIX THESE
  def fixture(:map) do
    {:ok, map} = Leagues.create_map(@create_attrs)
    map
  end

  describe "index" do
    test "lists all maps", %{conn: conn} do
      conn = get(conn, Routes.map_path(conn, :index))
      assert html_response(conn, 200) =~ "Current maps"
    end
  end

  describe "new map" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.map_path(conn, :new))
      assert html_response(conn, 200) =~ "New Map"
    end
  end

  describe "create map" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.map_path(conn, :create), map: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.map_path(conn, :show, id)

      conn = get(conn, Routes.map_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Map"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.map_path(conn, :create), map: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Map"
    end
  end

  describe "delete map" do
    setup [:create_map]

    test "deletes chosen map", %{conn: conn, map: map} do
      conn = delete(conn, Routes.map_path(conn, :delete, map))
      assert redirected_to(conn) == Routes.map_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.map_path(conn, :show, map))
      end
    end
  end

  defp create_map(_) do
    map = fixture(:map)
    {:ok, map: map}
  end
  """
end
