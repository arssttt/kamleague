defmodule Kamleague.Accounts.IpAddress do
  use Ecto.Schema

  schema "ip_addresses" do
    field :ip_address, :string
    belongs_to :user, Kamleague.Accounts.User
    timestamps()
  end

  def changeset(ip_address_or_changeset, attrs) do
    ip_address_or_changeset
    |> Ecto.Changeset.cast(attrs, [:ip_address])
  end
end
