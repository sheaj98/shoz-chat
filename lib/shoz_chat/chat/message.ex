defmodule ShozChat.Chat.Message do
  alias ShozChat.Accounts.User
  alias ShozChat.Chat.ChatRoom
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :content, :string

    belongs_to :chat_room, ChatRoom
    belongs_to :sender, User
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :sender_id, :chat_room_id])
    |> validate_required([:content, :sender_id, :chat_room_id])
  end
end
