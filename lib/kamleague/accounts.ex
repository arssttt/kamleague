defmodule Kamleague.Accounts do
  alias Kamleague.{Repo, Accounts.User}

  @type t :: %User{}

  def list_users() do
    User
    |> Repo.all()
    |> Repo.preload(:player)
  end

  def get_user!(id) do
    User
    |> Repo.get!(id)
    |> Repo.preload(:player)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def update_user(user, attrs) do
    user
    |> User.update_changeset(attrs)
    |> IO.inspect()
    |> Repo.update()
  end

  @spec lock(map()) :: {:ok, map()} | {:error, map()}
  def lock(user) do
    user
    |> User.lock_changeset()
    |> Repo.update()
  end
end
