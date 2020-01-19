defmodule Kamleague.Contents.Post do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :image, Kamleague.Image.Type
    field :title, :string
    field :subtitle, :string
    field :body, :string
    field :slug, :string
    belongs_to :user, Kamleague.Accounts.User
    belongs_to :tag, Kamleague.Contents.Tag

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    # Merge the slug with attrs
    attrs = Map.merge(attrs, slugify_title(attrs))

    post
    |> cast(attrs, [:title, :subtitle, :body, :tag_id, :slug])
    |> cast_attachments(attrs, [:image])
    |> validate_required([:title, :body, :tag_id])
  end

  # Transform title into our slug
  defp slugify_title(%{"title" => title}) do
    slug =
      title
      |> String.downcase()
      |> String.replace(~r/[^a-z0-9\s-]/, "")
      |> String.replace(~r/(\s|-)+/, "-")

    %{"slug" => slug}
  end

  # Need to have a function w/o title for our :new controller method
  defp slugify_title(_params) do
    %{}
  end
end
