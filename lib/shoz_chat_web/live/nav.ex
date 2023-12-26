defmodule ShozChatWeb.Nav do
  alias ShozChat.Chat
  import Phoenix.LiveView
  use Phoenix.Component

  def on_mount(:default, _params, _session, socket) do
    {:cont,
     socket
     |> stream(:chatrooms, Chat.list_chatrooms())
     |> attach_hook(:active_tab, :handle_params, &get_active_tab/3)}
  end

  defp get_active_tab(params, _url, socket) do
    active_tab_id = params["id"]
    {:cont, assign(socket, active_tab: active_tab_id)}
  end
end
