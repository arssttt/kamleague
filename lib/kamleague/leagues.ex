defmodule Kamleague.Leagues do
  @moduledoc """
  The Leagues context.
  """

  import Ecto.Query, warn: false
  alias Kamleague.Repo
  alias Kamleague.Elo

  alias Timex
  alias Kamleague.Leagues.Player

  @doc """
  Returns the list of players.
  """
  def list_players do
    Repo.all(Player)
  end

  @doc """
  Returns the list of active players.
  """
  def list_active_players do
    Repo.all(
      from p in Player,
        where: p.active == true,
        order_by: [desc: p.elo]
    )
  end

  @doc """
  Gets a single player.

  Raises `Ecto.NoResultsError` if the Player does not exist.

  ## Examples

      iex> get_player!(123)
      %Player{}

      iex> get_player!(456)
      ** (Ecto.NoResultsError)

  """
  def get_player!(id), do: Repo.get!(Player, id)

  @doc """
  Gets players from the ids
  """
  def get_players(ids) do
    Repo.all(from p in Player, where: p.id in ^ids)
  end

  @doc """
  Creates a player.

  ## Examples

      iex> create_player(%{field: value})
      {:ok, %Player{}}

      iex> create_player(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_player(attrs \\ %{}) do
    %Player{}
    |> Player.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a player.

  ## Examples

      iex> update_player(player, %{field: new_value})
      {:ok, %Player{}}

      iex> update_player(player, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_player(%Player{} = player, attrs) do
    player
    |> Player.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Player.

  ## Examples

      iex> delete_player(player)
      {:ok, %Player{}}

      iex> delete_player(player)
      {:error, %Ecto.Changeset{}}

  """
  def delete_player(%Player{} = player) do
    Repo.delete(player)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking player changes.

  ## Examples

      iex> change_player(player)
      %Ecto.Changeset{source: %Player{}}

  """
  def change_player(%Player{} = player) do
    Player.changeset(player, %{})
  end

  alias Kamleague.Leagues.Map

  @doc """
  Returns the list of maps.

  ## Examples

      iex> list_maps()
      [%Map{}, ...]

  """
  def list_maps do
    Repo.all(Map)
  end

  @doc """
  Gets a single map.

  Raises `Ecto.NoResultsError` if the Map does not exist.

  ## Examples

      iex> get_map!(123)
      %Map{}

      iex> get_map!(456)
      ** (Ecto.NoResultsError)

  """
  def get_map!(id), do: Repo.get!(Map, id)

  @doc """
  Creates a map.

  ## Examples

      iex> create_map(%{field: value})
      {:ok, %Map{}}

      iex> create_map(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_map(attrs \\ %{}) do
    %Map{}
    |> Map.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a map.

  ## Examples

      iex> update_map(map, %{field: new_value})
      {:ok, %Map{}}

      iex> update_map(map, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_map(%Map{} = map, attrs) do
    map
    |> Map.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Map.

  ## Examples

      iex> delete_map(map)
      {:ok, %Map{}}

      iex> delete_map(map)
      {:error, %Ecto.Changeset{}}

  """
  def delete_map(%Map{} = map) do
    Repo.delete(map)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking map changes.

  ## Examples

      iex> change_map(map)
      %Ecto.Changeset{source: %Map{}}

  """
  def change_map(%Map{} = map) do
    Map.changeset(map, %{})
  end

  alias Kamleague.Leagues.Game

  @doc """
  Returns the list of games.

  ## Examples

      iex> list_games()
      [%Game{}, ...]

  """
  def list_games(current_page, per_page) do
    Repo.all(
      from g in Game,
        preload: [[players: :player_info], :map],
        order_by: [desc: g.played_at],
        offset: ^((current_page - 1) * per_page),
        limit: ^per_page
    )
  end

  @doc """
  Gets a single game.

  Raises `Ecto.NoResultsError` if the Game does not exist.

  ## Examples

      iex> get_game!(123)
      %Game{}

      iex> get_game!(456)
      ** (Ecto.NoResultsError)

  """
  def get_game!(id), do: Repo.get!(Game, id) |> Repo.preload([[players: :player_info], :map])

  @doc """
  Creates a game.

  ## Examples

      iex> create_game(%{field: value})
      {:ok, %Game{}}

      iex> create_game(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_game(%Map{} = map, attrs \\ %{}) do
    # Convert the players map to atoms and add win parameter
    players =
      attrs["players"]
      |> Elixir.Map.values()
      |> Enum.map(fn x -> convert_to_atom_map(x) end)

    # Get winner information
    winner =
      players
      |> Enum.filter(fn player ->
        player.player_id == String.to_integer(attrs["winner_id"])
      end)
      |> List.first()

    winner_info = get_player!(winner.player_id)

    # Get loser information
    loser =
      Enum.filter(players, fn player ->
        player.player_id != String.to_integer(attrs["winner_id"])
      end)
      |> List.first()

    loser_info = get_player!(loser.player_id)

    {winner_new_elo, loser_new_elo} = Elo.rate(winner_info.elo, loser_info.elo, :win)

    winner =
      winner
      |> Elixir.Map.put(:win, true)
      |> Elixir.Map.put(:new_elo, winner_new_elo)
      |> Elixir.Map.put(:old_elo, winner_info.elo)

    loser =
      loser
      |> Elixir.Map.put(:win, false)
      |> Elixir.Map.put(:new_elo, loser_new_elo)
      |> Elixir.Map.put(:old_elo, loser_info.elo)

    # Format played_at to a DateTime
    attrs =
      case Elixir.Map.fetch(attrs, "played_at") do
        {:ok, _} ->
          Elixir.Map.put(
            attrs,
            "played_at",
            Timex.parse!(attrs["played_at"], "%d-%m-%Y %H:%M", :strftime)
          )

        :error ->
          attrs
      end

    game_changeset =
      %Game{}
      |> Game.changeset(attrs)
      |> Ecto.Changeset.put_change(:map_id, map.id)
      |> Ecto.Changeset.put_assoc(:players, [winner, loser])

    winner_changeset =
      winner_info
      |> Player.changeset_elo(%{elo: winner.new_elo})

    loser_changeset =
      loser_info
      |> Player.changeset_elo(%{elo: loser.new_elo})

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:game, game_changeset)
    |> Ecto.Multi.update(:winner, winner_changeset)
    |> Ecto.Multi.update(:loser, loser_changeset)
    |> Repo.transaction()
  end

  @doc """
  Changes String Map to Map of Atoms e.g. %{"c"=> "d", "x" => %{"yy" => "zz"}} to
          %{c: d, x: %{yy: zz}}, i.e changes even the nested maps.
  """
  def convert_to_atom_map(map), do: to_atom_map(map)

  defp to_atom_map(map) when is_map(map),
    do: Elixir.Map.new(map, fn {k, v} -> {String.to_atom(k), to_atom_map(v)} end)

  defp to_atom_map(v) when is_binary(v), do: String.to_integer(v)

  defp to_atom_map(v) when is_integer(v), do: v

  @doc """
  Updates a game.

  ## Examples

      iex> update_game(game, %{field: new_value})
      {:ok, %Game{}}

      iex> update_game(game, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_game(%Game{} = game, attrs) do
    game
    |> Game.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Game.

  ## Examples

      iex> delete_game(game)
      {:ok, %Game{}}

      iex> delete_game(game)
      {:error, %Ecto.Changeset{}}

  """
  def delete_game(%Game{} = game) do
    Repo.delete(game)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking game changes.

  ## Examples

      iex> change_game(game)
      %Ecto.Changeset{source: %Game{}}

  """
  def change_game(%Game{} = game) do
    Game.changeset(game, %{})
  end
end
