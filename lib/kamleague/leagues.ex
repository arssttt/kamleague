defmodule Kamleague.Leagues do
  @moduledoc """
  The Leagues context.
  """

  import Ecto.Query, warn: false
  alias Kamleague.Repo
  alias Kamleague.Elo
  alias Ecto.Multi

  alias Timex

  alias Kamleague.Leagues.{
    Player,
    PlayersGames,
    PlayersTeams,
    TeamsGames,
    Team,
    TeamsGamesPlayers
  }

  alias Kamleague.Accounts.User

  @doc """
  Returns the list of players.
  """
  def list_players do
    Repo.all(
      from p in Player,
        join: u in User,
        on: p.user_id == u.id and is_nil(u.locked_at),
        order_by: [desc: p.elo]
    )
  end

  @doc """
  Returns the list of active players.
  """
  def list_active_players do
    Repo.all(
      from p in Player,
        join: u in User,
        on: p.user_id == u.id and is_nil(u.locked_at),
        where: p.active == true,
        order_by: [desc: p.elo],
        preload: [:user]
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
  def get_player!(%_{} = user), do: Repo.get_by!(Player, user_id: user.id)
  def get_player!(id), do: Repo.get!(Player, id)

  def get_player_by_slug(slug) do
    Player
    |> Repo.get_by(slug: slug)
    |> Repo.preload([[games: :game], :user])
  end

  def get_player_with_games!(id) do
    Player
    |> Repo.get!(id)
    |> Repo.preload(:games)
  end

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

  def set_active(player, attrs) do
    player
    |> Player.changeset_active(attrs)
    |> Repo.update()
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
    |> Enum.sort(&(&1.slug < &2.slug))
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
  def list_games(params) do
    Game
    |> where([g], not g.deleted)
    |> order_by([g], desc: g.played_at)
    |> preload([
      [
        players: ^from(pg in PlayersGames, order_by: [desc: pg.player_id]),
        players: :player_info,
        teams: :team,
        teams: [players: :player]
      ],
      :map
    ])
    |> Repo.paginate(params)
  end

  def list_all_games() do
    Repo.all(
      from g in Game,
        preload: [[players: :player_info], [teams: :team], :map],
        order_by: g.id
    )
  end

  def list_unapproved_games(player) do
    query =
      from game in Game,
        join: p in PlayersGames,
        on:
          p.player_id == ^player.id and not p.approved and p.game_id == game.id and
            not game.deleted,
        preload: [[players: :player_info], :map]

    Repo.all(query)
  end

  def list_unapproved_team_games(player) do
    query =
      from game in Game,
        join: t in Team,
        on: t.owner_id == ^player.id,
        join: tg in TeamsGames,
        on:
          tg.team_id == t.id and not tg.approved and tg.game_id == game.id and
            not game.deleted,
        preload: [[teams: [players: :player]], [teams: :team], :map]

    Repo.all(query)
  end

  def list_games_player(player) do
    query =
      from game in Game,
        join: p in PlayersGames,
        on:
          p.player_id == ^player.id and p.game_id == game.id and
            not game.deleted,
        preload: [
          [
            players: ^from(pg in PlayersGames, order_by: [desc: pg.player_id]),
            players: :player_info
          ],
          :map
        ],
        order_by: [desc: game.played_at]

    Repo.all(query)
  end

  def list_games_team(team) do
    query =
      from game in Game,
        join: tg in TeamsGames,
        on:
          tg.team_id == ^team.id and tg.game_id == game.id and
            not game.deleted,
        preload: [
          [
            teams: :team,
            teams: [players: :player]
          ],
          :map
        ],
        order_by: [desc: game.played_at]

    Repo.all(query)
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

  def get_team_game!(id), do: Repo.get!(Game, id) |> Repo.preload([[teams: :players], :map])

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

    # Get winner
    winner =
      players
      |> Enum.filter(fn player ->
        player.player_id == String.to_integer(attrs["winner_id"])
      end)
      |> List.first()

    # Get loser
    loser =
      Enum.filter(players, fn player ->
        player.player_id != String.to_integer(attrs["winner_id"])
      end)
      |> List.first()

    winner =
      winner
      |> Elixir.Map.put(:win, true)

    loser =
      loser
      |> Elixir.Map.put(:win, false)

    # Format played_at to a DateTime
    attrs =
      case Elixir.Map.fetch(attrs, "played_at") do
        {:ok, _} ->
          Elixir.Map.put(
            attrs,
            "played_at",
            Timex.Timezone.convert(
              Timex.parse!(attrs["played_at"], "{ISO:Extended}"),
              Timex.Timezone.get("UTC", Timex.now())
            )
          )

        :error ->
          attrs
      end

    %Game{}
    |> Game.changeset(attrs)
    |> Ecto.Changeset.put_change(:map_id, map.id)
    |> Ecto.Changeset.put_assoc(:players, [winner, loser])
    |> Repo.insert()
  end

  def create_team_game(%Map{} = map, attrs \\ %{}) do
    # Convert the teams map to atoms and add win parameter
    teams =
      attrs["teams"]
      |> Elixir.Map.values()
      |> Enum.map(fn x -> convert_to_atom_map(x) end)

    # Get winner
    winner =
      teams
      |> Enum.filter(fn team ->
        team.team_id == String.to_integer(attrs["winner_id"])
      end)
      |> List.first()

    # Get loser
    loser =
      Enum.filter(teams, fn team ->
        team.team_id != String.to_integer(attrs["winner_id"])
      end)
      |> List.first()

    winner_players =
      winner.players
      |> Elixir.Map.values()

    winner =
      winner
      |> Elixir.Map.put(:win, true)
      |> Elixir.Map.put(:players, winner_players)

    loser_players =
      loser.players
      |> Elixir.Map.values()

    loser =
      loser
      |> Elixir.Map.put(:win, false)
      |> Elixir.Map.put(:players, loser_players)

    # Format played_at to a DateTime
    attrs =
      case Elixir.Map.fetch(attrs, "played_at") do
        {:ok, _} ->
          Elixir.Map.put(
            attrs,
            "played_at",
            Timex.Timezone.convert(
              Timex.parse!(attrs["played_at"], "{ISO:Extended}"),
              Timex.Timezone.get("UTC", Timex.now())
            )
          )

        :error ->
          attrs
      end

    %Game{}
    |> Game.changeset(attrs)
    |> Ecto.Changeset.put_change(:map_id, map.id)
    |> Ecto.Changeset.put_assoc(:teams, [winner, loser])
    |> Repo.insert()
  end

  @doc """
  Changes String Map to Map of Atoms e.g. %{"c"=> "d", "x" => %{"yy" => "zz"}} to
          %{c: d, x: %{yy: zz}}, i.e changes even the nested maps.
  """
  def convert_to_atom_map(map), do: to_atom_map(map)

  defp to_atom_map(map) when is_map(map),
    do: Elixir.Map.new(map, fn {k, v} -> {String.to_atom(k), to_atom_map(v)} end)

  defp to_atom_map(v) when v == "", do: nil

  defp to_atom_map(v) when is_binary(v), do: String.to_integer(v)

  defp to_atom_map(v) when is_integer(v), do: v

  defp to_atom_map(v) when is_boolean(v), do: v

  @doc """
  Calculates the elo for all the games. This calculates all the games from the beginning
  to calculate the elo correctly when approving and deleting games.
  """
  def calculate_elo() do
    # Reset all player data
    Repo.update_all(Player, set: [elo: 1000, wins: 0, losses: 0])

    games =
      Game
      |> preload(:players)
      |> order_by([g], asc: g.played_at)
      |> where([g], g.deleted == false and g.approved == true and g.type == "1v1")
      |> Repo.all()

    for game <- games do
      # Get winner and loser information
      winner = Enum.find(game.players, fn player -> player.win end)
      winner_info = get_player!(winner.player_id)
      loser = Enum.find(game.players, fn player -> !player.win end)
      loser_info = get_player!(loser.player_id)

      # Set the k factor
      k_factor = set_k_factor(game, games, [winner.player_id, loser.player_id])

      # Calculate their new elos
      {winner_new_elo, loser_new_elo} =
        Elo.rate(winner_info.elo, loser_info.elo, :win, round: true, k_factor: k_factor)

      game_changeset =
        game
        |> Game.changeset_k_factor(%{k_factor: k_factor})
        |> Ecto.Changeset.put_assoc(:players, [
          %{
            id: winner.id,
            game_id: winner.game_id,
            player_id: winner.player_id,
            new_elo: winner_new_elo,
            old_elo: winner_info.elo,
            new_wins: winner_info.wins + 1,
            old_wins: winner_info.wins,
            new_losses: winner_info.losses,
            old_losses: winner_info.losses
          },
          %{
            id: loser.id,
            game_id: loser.game_id,
            player_id: loser.player_id,
            new_elo: loser_new_elo,
            old_elo: loser_info.elo,
            new_wins: loser_info.wins,
            old_wins: loser_info.wins,
            new_losses: loser_info.losses + 1,
            old_losses: loser_info.losses
          }
        ])

      winner_changeset =
        winner_info
        |> Player.changeset_game(%{elo: winner_new_elo, wins: winner_info.wins + 1})

      loser_changeset =
        loser_info
        |> Player.changeset_game(%{elo: loser_new_elo, losses: loser_info.losses + 1})

      Multi.new()
      |> Multi.update(:game, game_changeset)
      |> Multi.update(:winner, winner_changeset)
      |> Multi.update(:loser, loser_changeset)
      |> Repo.transaction()
    end
  end

  defp set_k_factor(game, games, ids) do
    count =
      if game.type == "1v1" do
        games
        |> Enum.filter(fn g -> Enum.all?(g.players, fn p -> p.player_id in ids end) end)
        |> Enum.filter(fn g -> g.played_at <= game.played_at end)
        |> Enum.filter(fn g ->
          g.played_at >= Timex.beginning_of_month(game.played_at) and
            g.played_at <= Timex.end_of_month(game.played_at)
        end)
        |> Enum.count()
      else
        games
        |> Enum.filter(fn g -> Enum.all?(g.teams, fn p -> p.team_id in ids end) end)
        |> Enum.filter(fn g -> g.played_at <= game.played_at end)
        |> Enum.filter(fn g ->
          g.played_at >= Timex.beginning_of_month(game.played_at) and
            g.played_at <= Timex.end_of_month(game.played_at)
        end)
        |> Enum.count()
      end

    cond do
      count == 1 -> 100
      count == 2 -> 75
      count > 2 -> 50
    end
  end

  @doc """
  Calculates the elo for all the games. This calculates all the games from the beginning
  to calculate the elo correctly when approving and deleting games.
  """
  def calculate_team_elo() do
    # Reset all team data
    Repo.update_all(Team, set: [elo: 1000, wins: 0, losses: 0])

    games =
      Game
      |> preload(:teams)
      |> order_by([g], asc: g.played_at)
      |> where([g], g.deleted == false and g.approved == true and g.type == "2v2")
      |> Repo.all()

    for game <- games do
      # Get winner and loser information
      winner = Enum.find(game.teams, fn team -> team.win end)
      winner_info = get_team!(winner.team_id)
      loser = Enum.find(game.teams, fn team -> !team.win end)
      loser_info = get_team!(loser.team_id)

      # Set the k factor
      k_factor = set_k_factor(game, games, [winner.team_id, loser.team_id])

      # Calculate their new elos
      {winner_new_elo, loser_new_elo} =
        Elo.rate(winner_info.elo, loser_info.elo, :win, round: true, k_factor: k_factor)

      game_changeset =
        game
        |> Game.changeset_k_factor(%{k_factor: k_factor})
        |> Ecto.Changeset.put_assoc(:teams, [
          %{
            id: winner.id,
            game_id: winner.game_id,
            team_id: winner.team_id,
            new_elo: winner_new_elo,
            old_elo: winner_info.elo,
            new_wins: winner_info.wins + 1,
            old_wins: winner_info.wins,
            new_losses: winner_info.losses,
            old_losses: winner_info.losses
          },
          %{
            id: loser.id,
            game_id: loser.game_id,
            team_id: loser.team_id,
            new_elo: loser_new_elo,
            old_elo: loser_info.elo,
            new_wins: loser_info.wins,
            old_wins: loser_info.wins,
            new_losses: loser_info.losses + 1,
            old_losses: loser_info.losses
          }
        ])

      winner_changeset =
        winner_info
        |> Team.changeset_game(%{elo: winner_new_elo, wins: winner_info.wins + 1})

      loser_changeset =
        loser_info
        |> Team.changeset_game(%{elo: loser_new_elo, losses: loser_info.losses + 1})

      Multi.new()
      |> Multi.update(:game, game_changeset)
      |> Multi.update(:winner, winner_changeset)
      |> Multi.update(:loser, loser_changeset)
      |> Repo.transaction()
    end
  end

  def check_inactive() do
    players =
      Player
      |> preload(games: :game)
      |> Repo.all()

    for player <- players do
      Enum.find(player.games, fn g ->
        g.game.approved == true and g.game.deleted == false and
          Timex.diff(DateTime.utc_now(), g.game.played_at, :weeks) >=
            2
      end)
      |> case do
        %PlayersGames{} ->
          update_player(player, %{active: false})

        nil ->
          nil
      end
    end
  end

  @doc """
  Updates a game.

  ## Examples

      iex> update_game(game, %{field: new_value})
      {:ok, %Game{}}

      iex> update_game(game, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_game(%Game{} = game, attrs, type) do
    if type == "2v2" do
      # Update both teams approved status
      Enum.each(game.teams, fn team ->
        team
        |> TeamsGames.changeset_approve(%{approved: true})
        |> Repo.update()
      end)
    else
      # Update both players approved status
      Enum.each(game.players, fn player ->
        player
        |> PlayersGames.changeset_approve(%{approved: true})
        |> Repo.update()
      end)
    end

    game
    |> Game.changeset_update(attrs)
    |> Repo.update()
  end

  @doc """
  Approves a game
  """
  def approve_game(game, approved) do
    if game.type == "1v1" do
      player = Enum.find(game.players, fn player -> !player.approved end)

      game_changeset =
        game
        |> Game.changeset_approve()

      player_changeset =
        player
        |> PlayersGames.changeset_approve(%{approved: approved})

      Multi.new()
      |> Multi.update(:game, game_changeset)
      |> Multi.update(:player, player_changeset)
      |> Repo.transaction()
    else
      team = Enum.find(game.teams, fn team -> !team.approved end)

      game_changeset =
        game
        |> Game.changeset_approve()

      team_changeset =
        team
        |> TeamsGames.changeset_approve(%{approved: approved})

      Multi.new()
      |> Multi.update(:game, game_changeset)
      |> Multi.update(:team, team_changeset)
      |> Repo.transaction()
    end
  end

  @doc """
  Deletes a Game.

  ## Examples

      iex> delete_game(game)
      {:ok, %Game{}}

      iex> delete_game(game)
      {:error, %Ecto.Changeset{}}

  """
  def delete_game(game) do
    game
    |> Game.changeset_delete()
    |> Repo.update()
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

  alias Kamleague.Leagues.Team

  @doc """
  Returns the list of teams.

  ## Examples

      iex> list_teams()
      [%Team{}, ...]

  """
  def list_teams do
    Team
    |> preload([[players: :player_info], :owner])
    |> order_by([t], desc: t.id)
    |> Repo.all()
  end

  def list_approved_teams do
    Team
    |> preload(players: :player_info)
    |> where([t], t.approved)
    |> order_by([t], desc: t.elo)
    |> Repo.all()
  end

  def list_unapproved_teams(player) do
    query =
      from team in Team,
        join: pt in PlayersTeams,
        on: pt.player_id == ^player.id and not pt.joined and pt.team_id == team.id,
        preload: [:owner]

    Repo.all(query)
  end

  def list_approved_teams(player) do
    query =
      from team in Team,
        join: pt in PlayersTeams,
        on: pt.player_id == ^player.id and team.approved and pt.team_id == team.id,
        preload: [:owner]

    Repo.all(query)
  end

  @doc """
  Gets a single team.

  Raises `Ecto.NoResultsError` if the Team does not exist.

  ## Examples

      iex> get_team!(123)
      %Team{}

      iex> get_team!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team!(id), do: Repo.get!(Team, id) |> Repo.preload(:players)

  def get_team_by_slug!(slug),
    do: Repo.get_by!(Team, slug: slug) |> Repo.preload([[players: :player_info], :owner])

  @doc """
  Creates a team.

  ## Examples

      iex> create_team(%{field: value})
      {:ok, %Team{}}

      iex> create_team(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team(player, attrs) do
    %Team{}
    |> Team.changeset(attrs)
    |> Ecto.Changeset.put_change(:owner_id, player.id)
    |> Ecto.Changeset.put_assoc(:players, [
      %{player_id: player.id, joined: true},
      %{player_id: String.to_integer(attrs["teammate"])}
    ])
    |> check_amount_teams(attrs["teammate"])
    |> Repo.insert()
  end

  defp check_amount_teams(changeset, id) do
    player = Repo.get!(Player, id) |> Repo.preload(:teams)

    case length(player.teams) do
      2 ->
        changeset
        |> Ecto.Changeset.add_error(:teammate, "Teammate is already in 2 teams.")

      _ ->
        changeset
    end
  end

  @doc """
  Updates a team.

  ## Examples

      iex> update_team(team, %{field: new_value})
      {:ok, %Team{}}

      iex> update_team(team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  def approve_team(%Team{} = team) do
    Enum.each(team.players, fn player ->
      player
      |> PlayersTeams.changeset_join(%{joined: true})
      |> Repo.update()
    end)

    team
    |> Team.changeset_approve()
    |> Repo.update()
  end

  @doc """
  Deletes a Team.

  ## Examples

      iex> delete_team(team)
      {:ok, %Team{}}

      iex> delete_team(team)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team(%Team{} = team) do
    Repo.delete(team)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team changes.

  ## Examples

      iex> change_team(team)
      %Ecto.Changeset{source: %Team{}}

  """
  def change_team(%Team{} = team) do
    Team.changeset(team, %{})
  end
end
