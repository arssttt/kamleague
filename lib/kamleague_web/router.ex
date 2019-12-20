defmodule KamleagueWeb.Router do
  use KamleagueWeb, :router
  use Pow.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug KamleagueWeb.AssignUser
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: KamleagueWeb.AuthErrorHandler
  end

  pipeline :not_authenticated do
    plug Pow.Plug.RequireNotAuthenticated,
      error_handler: KamleagueWeb.AuthErrorHandler
  end

  pipeline :admin do
    plug KamleagueWeb.EnsureRolePlug, :admin
  end

  scope "/", KamleagueWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/maps", MapController, :index
    resources "/games", GameController
  end

  scope "/", KamleagueWeb do
    pipe_through [:browser, :not_authenticated]

    get "/signup", RegistrationController, :new, as: :signup
    post "/signup", RegistrationController, :create, as: :signup
    get "/login", SessionController, :new, as: :login
    post "/login", SessionController, :create, as: :login
  end

  scope "/", KamleagueWeb do
    pipe_through [:browser, :protected]

    delete "/logout", SessionController, :delete, as: :logout
  end

  scope "/", KamleagueWeb do
    pipe_through [:browser, :admin]

    resources "/maps", MapController, only: [:new, :create, :edit, :delete]
  end
end
