defmodule Kamleague.Contents.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :body, :string
    field :title, :string
    belongs_to :user, Kamleague.Accounts.User
    belongs_to :tag, Kamleague.Contents.Tag

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body, :tag_id])
    |> validate_required([:title, :body, :tag_id])
  end
end
