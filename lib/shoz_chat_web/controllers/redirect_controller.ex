defmodule ShozChatWeb.RedirectController do
  use ShozChatWeb, :controller

  def root(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    if conn.assigns[:user] do
      redirect(conn, to: "/chatrooms")
    else
      redirect(conn, to: "/login")
    end
  end
end
