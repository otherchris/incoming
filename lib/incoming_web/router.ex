defmodule IncomingWeb.Router do
  use IncomingWeb, :router

  pipeline :guardian do
    plug IncomingWeb.Authentication.Pipeline
  end

  pipeline :browser_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/hooks", IncomingWeb do
    pipe_through :api

    post "/incoming-voice", HooksController, :incoming_voice
    post "/end-call/:call_number", HooksController, :end_call
  end

  scope "/", IncomingWeb do
    pipe_through [:browser, :guardian]

    get "/", PageController, :index
    get "/register", UserController, :new
    post "/users", UserController, :create
    post "/confirm-phone", UserController, :confirm_phone_and_insert_user
    get "/login", SessionController, :new
    post "/session", SessionController, :create
  end

  scope "/", IncomingWeb do
    pipe_through [:browser, :guardian, :browser_auth]

    get "/dashboard", UserController, :dashboard
    get "/shifts", ShiftController, :index
    post "/shifts/switch", ShiftController, :switch
    post "/shifts/sign-up", ShiftController, :sign_up
    get "/logout", SessionController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", IncomingWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  scope "/", IncomingWeb do
    pipe_through [:browser, :guardian, :browser_auth]
    get "/live_dashboard", MetricsController, :index
  end
end
