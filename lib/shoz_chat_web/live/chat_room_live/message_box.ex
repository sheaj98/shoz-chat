defmodule ShozChatWeb.ChatRoomLive.MessageBox do
  use ShozChatWeb, :live_component
  import ShozChatWeb.CoreComponents
  alias ShozChat.Chat
  alias ShozChat.Chat.Message

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_changeset}
  end

  def assign_changeset(socket) do
    assign(socket, :changeset, Chat.change_message(%Message{}))
  end

  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        :let={f}
        for={@changeset}
        phx-submit="save"
        phx-change="update"
        phx-target={@myself}
      >
        <.input
          autocomplete="off"
          name="content"
          field={f[:content]}
          phx-focus="unpin_scrollbar_from_top"
        />
        <:actions>
          <.button>Send</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def handle_event("update", %{"content" => content}, socket) do
    {:noreply, socket |> assign(:changeset, Chat.change_message(%Message{content: content}))}
  end

  def handle_event("save", %{"content" => content}, socket) do
    Chat.create_message(%{
      content: content,
      chat_room_id: socket.assigns.chat_room_id,
      sender_id: socket.assigns.sender_id
    })

    {:noreply, assign_changeset(socket)}
  end
end
