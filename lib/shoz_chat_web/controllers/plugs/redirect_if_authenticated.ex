defmodule ShozChatWeb.Plugs.RedirectIfAuthenticated do
  import Plug.Conn
  import Phoenix.Controller
  use ShozChatWeb, :verified_routes

  def init(opts), do: opts

  def call(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
      |> redirect(to: ~p"/chatrooms")
      |> halt()
    else
      conn
    end
  end
end
