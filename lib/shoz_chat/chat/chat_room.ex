defmodule ShozChat.Chat.ChatRoom do
  alias ShozChat.Chat.Message
  use Ecto.Schema
  import Ecto.Changeset

  schema "chatrooms" do
    field :name, :string
    field :description, :string

    has_many :messages, Message

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(chat_room, attrs) do
    chat_room
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
