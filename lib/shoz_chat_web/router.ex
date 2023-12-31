defmodule ShozChatWeb.Router do
  use ShozChatWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ShozChatWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug ShozChatWeb.Plugs.SetUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/auth", ShozChatWeb do
    pipe_through :browser

    get "/signout", AuthController, :signout
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  scope "/", ShozChatWeb do
    pipe_through :browser

    get "/", RedirectController, :root
    get "/login", AuthController, :login

    live_session :authenticated,
      on_mount: [{ShozChatWeb.Auth, :ensure_authenticated}, ShozChatWeb.Nav] do
      live "/chatrooms", ChatRoomLive.Index, :index
      live "/chatrooms/new", ChatRoomLive.Index, :new
      live "/chatrooms/:id", ChatRoomLive.Show, :show
      live "/chatrooms/:id/edit", ChatRoomLive.Show, :edit
      live "/chatrooms/:id/new", ChatRoomLive.Show, :new
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", ShozChatWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:shoz_chat, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ShozChatWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
