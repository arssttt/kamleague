defmodule Kamleague.Contents.Post do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :thumbnail, Kamleague.Thumbnail.Type
    field :title, :string
    field :body, :string
    belongs_to :user, Kamleague.Accounts.User
    belongs_to :tag, Kamleague.Contents.Tag

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body, :tag_id])
    |> cast_attachments(attrs, [:thumbnail])
    |> validate_required([:thumbnail, :title, :body, :tag_id])
  end
end
