defmodule ShozChatWeb.ChatRoomLive.FormComponent do
  use ShozChatWeb, :live_component

  alias ShozChat.Chat

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
      </.header>

      <.simple_form
        for={@form}
        id="chat_room-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="text" label="Description" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Chat room</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{chat_room: chat_room} = assigns, socket) do
    changeset = Chat.change_chat_room(chat_room)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"chat_room" => chat_room_params}, socket) do
    changeset =
      socket.assigns.chat_room
      |> Chat.change_chat_room(chat_room_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"chat_room" => chat_room_params}, socket) do
    save_chat_room(socket, socket.assigns.action, chat_room_params)
  end

  defp save_chat_room(socket, :edit, chat_room_params) do
    case Chat.update_chat_room(socket.assigns.chat_room, chat_room_params) do
      {:ok, chat_room} ->
        notify_parent({:saved, chat_room})

        {:noreply,
         socket
         |> put_flash(:info, "Chat room updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_chat_room(socket, :new, chat_room_params) do
    case Chat.create_chat_room(chat_room_params) do
      {:ok, chat_room} ->
        notify_parent({:saved, chat_room})

        {:noreply,
         socket
         |> put_flash(:info, "Chat room created successfully")
         |> redirect(to: "/chatrooms/#{chat_room.id}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
