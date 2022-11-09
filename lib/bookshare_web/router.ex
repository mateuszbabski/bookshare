defmodule BookshareWeb.Router do
  use BookshareWeb, :router

  import BookshareWeb.Auth

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_current_user
  end

  pipeline :protected do
    plug :require_authenticated_user
  end

  scope "/api/user", BookshareWeb do
    pipe_through [:api, :protected]

    post "/create", ProfileController, :create
    patch "/update", ProfileController, :update
    get "/account", ProfileController, :show_me
  end

  scope "/api/user", BookshareWeb do
    pipe_through :api

    get "/all", ProfileController, :index
    get "/:id", ProfileController, :show
  end

  scope "/api/auth", BookshareWeb do
    pipe_through [:api, :protected]

    get "/", AuthController, :index
    patch "/", AuthController, :update
    delete "/logout", AuthController, :logout
  end

  scope "/api/auth", BookshareWeb do
    pipe_through :api

    post "/login", AuthController, :login
    post "/register", AuthController, :register
    post "/confirm", AuthController, :confirm_email
    post "/forgot_password", AuthController, :forgot_password
    post "/reset_password", AuthController, :reset_password
  end

  scope "/api/books", BookshareWeb do
    pipe_through :api

    resources "/books", BookController, except: [:new, :edit]
  end

    scope "/api/books", BookshareWeb do
    pipe_through [:api, :protected]

    #resources "/books", BookController, except: [:new, :edit]
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
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: BookshareWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
