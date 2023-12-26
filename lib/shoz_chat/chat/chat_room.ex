defmodule ShozChat.Chat.ChatRoom do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chatrooms" do
    field :name, :string
    field :description, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(chat_room, attrs) do
    chat_room
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
