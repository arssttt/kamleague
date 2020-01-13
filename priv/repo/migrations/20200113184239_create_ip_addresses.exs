defmodule Kamleague.Repo.Migrations.CreateIpAddresses do
  use Ecto.Migration

  def change do
    create table(:ip_addresses) do
      add :ip_address, :string
      add :user_id, references(:users, on_delete: :nothing)
      timestamps()
    end

    create index(:ip_addresses, [:user_id])
  end
end
