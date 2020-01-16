defmodule Kamleague.Repo.Migrations.AddThumbnailToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :thumbnail, :string
    end
  end
end
