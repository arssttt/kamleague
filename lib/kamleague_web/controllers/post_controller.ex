defmodule KamleagueWeb.PostController do
  use KamleagueWeb, :controller

  alias Kamleague.Contents

  def index(conn, _params) do
    posts = Contents.list_posts("News")
    render(conn, "index.html", posts: posts)
  end

  def show(conn, %{"slug" => slug}) do
    post = Contents.get_post_by_slug!(slug)
    render(conn, "show.html", post: post)
  end
end
