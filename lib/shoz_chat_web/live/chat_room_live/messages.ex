defmodule ShozChatWeb.ChatRoomLive.Messages do
  use Phoenix.Component

  def list_messages(assigns) do
    ~H"""
    <div
      id="messages"
      phx-update="stream"
      class="overflow-scroll flex-auto mt-3"
      style="height: calc(88vh - 10rem)"
      phx-hook="ScrollDown"
      data-scrolled-to-top={@scrolled_to_top}
    >
      <div id="infinite-scroll-marker" phx-hook="InfiniteScroll"></div>
      <div :for={{dom_id, message} <- @messages} id={dom_id} class="mt-2">
        <.message_details message={message} />
      </div>
    </div>
    """
  end

  def message_details(assigns) do
    ~H"""
    <div class="flex flex-col">
      <div>
        <%= @message.sender.email %>
      </div>
      <div class="bg-gray-100 p-2 rounded">
        <%= @message.content %>
      </div>
    </div>
    """
  end
end
