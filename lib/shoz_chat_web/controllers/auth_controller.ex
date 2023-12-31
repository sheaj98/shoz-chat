defmodule ShozChatWeb.AuthController do
  use ShozChatWeb, :controller
  plug Ueberauth

  plug ShozChatWeb.Plugs.RedirectIfAuthenticated when action == :login

  alias ShozChat.Accounts

  def login(conn, _params) do
    render(conn, :login, layout: false)
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_data = %{token: auth.credentials.token, email: auth.info.email, provider: "github"}

    case Accounts.get_or_create_user(user_data) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome to ShozChat")
        |> put_session(:user_id, user.id)
        |> redirect(to: "/")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Something went wrong")
        |> redirect(to: "/")
    end
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: "/login")
  end
end
