defmodule ShozChatWeb.PageController do
  use ShozChatWeb, :controller

  def root(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    if conn.assigns[:user] do
      render(conn, :home)
    else
      redirect(conn, to: "/login")
    end
  end

  def login(conn, _params) do
    render(conn, :login, layout: false)
  end
end
