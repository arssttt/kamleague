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
    get "/rules", PageController, :rules
    get "/elo", PageController, :elo
    get "/faq", PageController, :faq
    get "/downloads", PageController, :downloads
    get "/old-rankings", PageController, :oldrankings

    resources "/news", PostController, only: [:index, :show], param: "slug"

    scope "/statistics" do
      get "/games", StatisticsController, :games
    end

    resources "/players", PlayerController, only: [:show], param: "slug"
    resources "/teams", TeamController, only: [:show], param: "slug"
  end

  scope "/", KamleagueWeb do
    pipe_through [:browser, :not_authenticated]

    get "/signup", RegistrationController, :new, as: :signup
    post "/signup", RegistrationController, :create, as: :signup
    get "/login", SessionController, :new, as: :login
    post "/login", SessionController, :create, as: :login
    resources "/reset-password", ResetPasswordController, only: [:new, :create, :update]
    get "/reset-password/:id", ResetPasswordController, :edit
  end

  scope "/", KamleagueWeb do
    pipe_through [:browser, :protected]
    resources "/games", GameController, only: [:update, :delete]

    resources "/maps", MapController, only: [:index] do
      post "/games/team", GameController, :create_team
      resources "/games", GameController, only: [:new, :create]
    end

    resources "/teams", TeamController, only: [:create, :update, :delete]
    resources "/players", PlayerController, only: [:update]
    delete "/logout", SessionController, :delete, as: :logout

    scope "/team" do
      get "/new", TeamController, :new
    end
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
