defmodule Kamleague.Accounts do
  alias Kamleague.{Repo, Accounts.IpAddress, Accounts.User}

  import Ecto.Query

  @type t :: %User{}

  def list_users() do
    User
    |> Repo.all()
    |> Repo.preload([:player, :ip_addresses])
  end

  def get_user!(id) do
    User
    |> Repo.get!(id)
    |> Repo.preload([:player])
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def update_user(user, attrs) do
    user
    |> User.update_changeset(attrs)
    |> Repo.update()
  end

  def update_user_ip(conn) do
    user = conn.assigns.current_user

    query =
      from i in IpAddress,
        where:
          i.ip_address == ^to_string(:inet_parse.ntoa(conn.remote_ip)) and i.user_id == ^user.id

    Repo.one(query)
    |> case do
      nil -> %IpAddress{ip_address: to_string(:inet_parse.ntoa(conn.remote_ip))}
      ip_address -> ip_address
    end
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_change(:user_id, user.id)
    |> Repo.insert_or_update()
  end

  @spec lock(map()) :: {:ok, map()} | {:error, map()}
  def lock(user) do
    user
    |> User.lock_changeset()
    |> Repo.update()
  end
end
