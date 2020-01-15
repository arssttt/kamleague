defmodule Kamleague.Repo.Migrations.AddCountryCodeToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :country_code, :string
    end
  end
end
