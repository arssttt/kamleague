defmodule Kamleague.Repo.Migrations.RenameThumbnailToImage do
  use Ecto.Migration

  def change do
    rename table("posts"), :thumbnail, to: :image
  end
end
