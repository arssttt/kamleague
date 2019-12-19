defmodule Kamleague.LeaguesTest do
  use Kamleague.DataCase

  alias Kamleague.Leagues

  describe "players" do
    alias Kamleague.Leagues.Player

    @valid_attrs %{elo: 42, nickname: "some nickname"}
    @update_attrs %{elo: 43, nickname: "some updated nickname"}
    @invalid_attrs %{elo: nil, nickname: nil}

    def player_fixture(attrs \\ %{}) do
      {:ok, player} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Leagues.create_player()

      player
    end

    test "list_players/0 returns all players" do
      player = player_fixture()
      assert Leagues.list_players() == [player]
    end

    test "get_player!/1 returns the player with given id" do
      player = player_fixture()
      assert Leagues.get_player!(player.id) == player
    end

    test "create_player/1 with valid data creates a player" do
      assert {:ok, %Player{} = player} = Leagues.create_player(@valid_attrs)
      assert player.elo == 42
      assert player.nickname == "some nickname"
    end

    test "create_player/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Leagues.create_player(@invalid_attrs)
    end

    test "update_player/2 with valid data updates the player" do
      player = player_fixture()
      assert {:ok, %Player{} = player} = Leagues.update_player(player, @update_attrs)
      assert player.elo == 43
      assert player.nickname == "some updated nickname"
    end

    test "update_player/2 with invalid data returns error changeset" do
      player = player_fixture()
      assert {:error, %Ecto.Changeset{}} = Leagues.update_player(player, @invalid_attrs)
      assert player == Leagues.get_player!(player.id)
    end

    test "delete_player/1 deletes the player" do
      player = player_fixture()
      assert {:ok, %Player{}} = Leagues.delete_player(player)
      assert_raise Ecto.NoResultsError, fn -> Leagues.get_player!(player.id) end
    end

    test "change_player/1 returns a player changeset" do
      player = player_fixture()
      assert %Ecto.Changeset{} = Leagues.change_player(player)
    end
  end

  describe "maps" do
    alias Kamleague.Leagues.Map

    @valid_attrs %{locations: 42, name: "some name"}
    @update_attrs %{locations: 43, name: "some updated name"}
    @invalid_attrs %{locations: nil, name: nil}

    def map_fixture(attrs \\ %{}) do
      {:ok, map} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Leagues.create_map()

      map
    end

    test "list_maps/0 returns all maps" do
      map = map_fixture()
      assert Leagues.list_maps() == [map]
    end

    test "get_map!/1 returns the map with given id" do
      map = map_fixture()
      assert Leagues.get_map!(map.id) == map
    end

    test "create_map/1 with valid data creates a map" do
      assert {:ok, %Map{} = map} = Leagues.create_map(@valid_attrs)
      assert map.locations == 42
      assert map.name == "some name"
    end

    test "create_map/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Leagues.create_map(@invalid_attrs)
    end

    test "update_map/2 with valid data updates the map" do
      map = map_fixture()
      assert {:ok, %Map{} = map} = Leagues.update_map(map, @update_attrs)
      assert map.locations == 43
      assert map.name == "some updated name"
    end

    test "update_map/2 with invalid data returns error changeset" do
      map = map_fixture()
      assert {:error, %Ecto.Changeset{}} = Leagues.update_map(map, @invalid_attrs)
      assert map == Leagues.get_map!(map.id)
    end

    test "delete_map/1 deletes the map" do
      map = map_fixture()
      assert {:ok, %Map{}} = Leagues.delete_map(map)
      assert_raise Ecto.NoResultsError, fn -> Leagues.get_map!(map.id) end
    end

    test "change_map/1 returns a map changeset" do
      map = map_fixture()
      assert %Ecto.Changeset{} = Leagues.change_map(map)
    end
  end

  describe "games" do
    alias Kamleague.Leagues.Game

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def game_fixture(attrs \\ %{}) do
      {:ok, game} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Leagues.create_game()

      game
    end

    test "list_games/0 returns all games" do
      game = game_fixture()
      assert Leagues.list_games() == [game]
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()
      assert Leagues.get_game!(game.id) == game
    end

    test "create_game/1 with valid data creates a game" do
      assert {:ok, %Game{} = game} = Leagues.create_game(@valid_attrs)
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Leagues.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()
      assert {:ok, %Game{} = game} = Leagues.update_game(game, @update_attrs)
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()
      assert {:error, %Ecto.Changeset{}} = Leagues.update_game(game, @invalid_attrs)
      assert game == Leagues.get_game!(game.id)
    end

    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Game{}} = Leagues.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> Leagues.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = Leagues.change_game(game)
    end
  end
end
