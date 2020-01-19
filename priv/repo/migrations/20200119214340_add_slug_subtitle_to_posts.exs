defmodule Kamleague.Repo.Migrations.AddSlugSubtitleToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :subtitle, :string
      add :slug, :string
    end

    create unique_index(:posts, [:slug])
  end
end
