defmodule ShozChatWeb.ChatRoomLive.Index do
  use ShozChatWeb, :live_view

  alias ShozChat.Chat
  alias ShozChat.Chat.ChatRoom

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Chat room")
    |> assign(:chat_room, Chat.get_chat_room!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Chat room")
    |> assign(:chat_room, %ChatRoom{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Chatrooms")
    |> assign(:chat_room, nil)
  end

  @impl true
  def handle_info({ShozChatWeb.ChatRoomLive.FormComponent, {:saved, chat_room}}, socket) do
    {:noreply, stream_insert(socket, :chatrooms, chat_room)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    chat_room = Chat.get_chat_room!(id)
    {:ok, _} = Chat.delete_chat_room(chat_room)

    {:noreply, stream_delete(socket, :chatrooms, chat_room)}
  end
end
