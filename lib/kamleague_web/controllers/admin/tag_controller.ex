defmodule KamleagueWeb.Admin.TagController do
  use KamleagueWeb, :controller

  alias Kamleague.Contents

  def create(conn, %{"tag" => tag_params}) do
    case Contents.create_tag(tag_params) do
      {:ok, _tag} ->
        conn
        |> put_flash(:info, "Tag created successfully.")
        |> redirect(to: Routes.admin_post_path(conn, :index))

      {:error, _changeset} ->
        conn
        |> redirect(to: Routes.admin_post_path(conn, :index))
    end
  end

  def delete(conn, %{"id" => id}) do
    tag = Contents.get_tag!(id)
    {:ok, _tag} = Contents.delete_tag(tag)

    conn
    |> put_flash(:info, "Tag deleted successfully.")
    |> redirect(to: Routes.admin_post_path(conn, :index))
  end
end
