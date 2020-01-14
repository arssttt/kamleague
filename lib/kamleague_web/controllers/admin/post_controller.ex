defmodule KamleagueWeb.Admin.PostController do
  use KamleagueWeb, :controller

  alias Kamleague.Contents
  alias Kamleague.Contents.{Post, Tag}

  def index(conn, _params) do
    posts = Contents.list_posts()
    tags = Contents.list_tags()
    changeset = Contents.change_tag(%Tag{})
    render(conn, "index.html", changeset: changeset, posts: posts, tags: tags)
  end

  def new(conn, _params) do
    tags = Contents.list_tags()
    changeset = Contents.change_post(%Post{})
    render(conn, "new.html", changeset: changeset, tags: tags)
  end

  def create(conn, %{"post" => post_params}) do
    tags = Contents.list_tags()

    case Contents.create_post(Pow.Plug.current_user(conn), post_params) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Routes.admin_post_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, tags: tags)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Contents.get_post!(id)
    render(conn, "show.html", post: post)
  end

  def edit(conn, %{"id" => id}) do
    post = Contents.get_post!(id)
    tags = Contents.list_tags()
    changeset = Contents.change_post(post)
    render(conn, "edit.html", post: post, changeset: changeset, tags: tags)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Contents.get_post!(id)

    case Contents.update_post(post, post_params) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: Routes.admin_post_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Contents.get_post!(id)
    {:ok, _post} = Contents.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: Routes.admin_post_path(conn, :index))
  end
end
