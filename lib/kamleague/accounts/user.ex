defmodule Kamleague.Accounts.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  schema "users" do
    field :username, :string
    field :role, :string, default: "user"
    field :locked_at, :utc_datetime

    pow_user_fields()

    has_one :player, Kamleague.Leagues.Player
    has_many :posts, Kamleague.Contents.Post
    has_many :ip_addresses, Kamleague.Accounts.IpAddress

    timestamps()
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> Ecto.Changeset.cast(attrs, [:username, :locked_at])
    |> Ecto.Changeset.cast_assoc(:player)
    |> Ecto.Changeset.validate_required([:username, :player])
  end

  def update_changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> Ecto.Changeset.cast(attrs, [:username, :role, :locked_at])
    |> Ecto.Changeset.cast_assoc(:player)
    |> Ecto.Changeset.validate_inclusion(:role, ~w(user admin))
    |> Ecto.Changeset.validate_required([:username, :player])
  end

  @spec lock_changeset(Ecto.Schema.t() | Ecto.Changeset.t()) :: Ecto.Changeset.t()
  def lock_changeset(user_or_changeset) do
    changeset = Ecto.Changeset.change(user_or_changeset)
    locked_at = DateTime.from_unix!(System.system_time(:second), :second)

    case changeset do
      %{data: %{locked_at: nil}} -> Ecto.Changeset.change(changeset, locked_at: locked_at)
      changeset -> changeset
    end
  end
end
