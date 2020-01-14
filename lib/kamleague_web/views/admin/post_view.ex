defmodule KamleagueWeb.Admin.PostView do
  use KamleagueWeb, :view

  def markdown(body) do
    body
    |> Earmark.as_html!()
  end
end
