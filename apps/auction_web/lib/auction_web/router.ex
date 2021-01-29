defmodule AuctionWeb.Router do
  use AuctionWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug AuctionWeb.Authenticator
  end

  pipeline :api do
    plug :accepts, ["json"]
    # # plug :fetch_session
    # # plug :fetch_flash
    # plug AuctionWeb.Authenticator
  end

  scope "/", AuctionWeb do
    pipe_through :browser

    # Routes for loggin in, creating, or deleting a session
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete

    get "/", PageController, :index
    resources "/users", UserController, only: [:show, :new, :create]
    resources "/items", ItemController, only: [:index, :show, :new, :create, :edit, :update] do
      resources "/bids", BidController, only: [:create]
    end

    # ^ defines all of the following RESTful routes by convention
    # get "/items",         ItemController, :index
    # get "/items/new",     ItemController, :new
    # post "/items",        ItemController, :create
    # get "/items/:id",     ItemController, :show
    # get "/items/:id/edt", ItemController, :edit
    # patch "/items/:id",   ItemController, :update
    # put "/items/:id",     ItemController, :update
    # delete "/items/:id",  ItemController, :delete

  end

  # Other scopes may use custom stacks.
  scope "/api", AuctionWeb.Api do
    pipe_through :api

    resources "/items", ItemController, only: [:index, :show]
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: AuctionWeb.Telemetry
    end
  end
end
