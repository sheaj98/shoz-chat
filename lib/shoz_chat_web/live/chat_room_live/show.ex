defmodule ShozChatWeb.ChatRoomLive.Show do
  use ShozChatWeb, :live_view
  alias ShozChatWeb.Endpoint

  alias ShozChat.Chat
  alias ShozChat.Chat.ChatRoom
  alias ShozChatWeb.ChatRoomLive.Messages

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

  defp apply_action(socket, :new, %{"id" => id}) do
    socket
    |> assign(:page_title, "New Chat room")
    |> assign(:chat_room, Chat.get_chat_room!(id))
    |> assign_message_stream()
    |> assign_scrolled_to_top()
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    if connected?(socket), do: Endpoint.subscribe("room:#{id}")

    socket
    |> assign(:page_title, "Show Chatroom")
    |> assign(:chat_room, Chat.get_chat_room!(id))
    |> assign_message_stream()
    |> assign_scrolled_to_top()
  end

  defp assign_scrolled_to_top(socket, scrolled_to_top \\ "false") do
    assign(socket, :scrolled_to_top, scrolled_to_top)
  end

  defp assign_oldest_message_id(socket, message) do
    if message != nil do
      assign(socket, :oldest_message_id, message.id)
    else
      socket
    end
  end

  defp assign_message_stream(socket) do
    messages = Chat.get_messages_for_room(socket.assigns.chat_room.id)

    socket
    |> stream(:messages, messages)
    |> assign_oldest_message_id(List.first(messages))
  end

  @impl true
  def handle_info({ShozChatWeb.ChatRoomLive.FormComponent, {:saved, chat_room}}, socket) do
    {:noreply, stream_insert(socket, :chatrooms, chat_room)}
  end

  @impl true
  def handle_info(%{event: "new_message", payload: %{message: message}}, socket) do
    {:noreply,
     socket
     |> insert_new_message(message)}
  end

  @impl true
  def handle_info(%{event: "updated_message", payload: %{message: message}}, socket) do
    {:noreply,
     socket
     |> insert_updated_message(message)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    chat_room = Chat.get_chat_room!(id)
    {:ok, _} = Chat.delete_chat_room(chat_room)

    stream_delete(socket, :chatrooms, chat_room)
    {:noreply, push_navigate(socket, to: "/chatrooms")}
  end

  @impl true
  def handle_event("load_more", _params, socket) do
    if socket.assigns[:oldest_message_id] == nil do
      {:noreply, socket}
    else
      messages =
        Chat.get_previous_n_messages(
          socket.assigns.oldest_message_id,
          socket.assigns.chat_room.id,
          5
        )

      {:noreply,
       socket
       |> stream(:messages, messages, at: 0)
       |> assign_oldest_message_id(List.last(messages))
       |> assign_scrolled_to_top("true")}
    end
  end

  @impl true
  def handle_event("unpin_scrollbar_from_top", _params, socket) do
    {:noreply,
     socket
     |> assign_scrolled_to_top("false")}
  end

  def insert_new_message(socket, message) do
    socket
    |> stream_insert(:messages, Chat.preload_message_sender(message))
  end

  def insert_updated_message(socket, message) do
    socket
    |> stream_insert(:messages, Chat.preload_message_sender(message), at: -1)
  end
end
