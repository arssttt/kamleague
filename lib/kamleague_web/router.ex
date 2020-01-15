defmodule KamleagueWeb.Router do
  use KamleagueWeb, :router
  use Pow.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug KamleagueWeb.AssignUser
    plug KamleagueWeb.EnsureUserNotLockedPlug
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
    get "/how-to-play", PageController, :howtoplay
    get "/rules", PageController, :rules
    get "/faq", PageController, :faq
    get "/news", PageController, :news
    get "/downloads", PageController, :downloads

    scope "/statistics" do
      get "/games", StatisticsController, :games
    end

    resources "/maps", MapController, only: [:index] do
      resources "/games", GameController
    end
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
    resources "/games", GameController, only: [:update, :delete]
    resources "/players", PlayerController, only: [:update]
    resources "/teams", TeamController
    delete "/logout", SessionController, :delete, as: :logout
  end

  scope "/admin", KamleagueWeb, as: :admin do
    pipe_through [:browser, :admin]
    resources "/posts", Admin.PostController
    resources "/tags", Admin.TagController
    resources "/maps", Admin.MapController, except: [:show]
    resources "/games", Admin.GameController, only: [:index, :delete, :update]
    resources "/users", Admin.UserController
  end
end
