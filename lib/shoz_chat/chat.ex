defmodule ShozChat.Chat do
  @moduledoc """
  The Chat context.
  """

  import Ecto.Query, warn: false
  alias ShozChat.Chat.Message
  alias ShozChat.Repo

  alias ShozChat.Chat.ChatRoom

  alias ShozChatWeb.Endpoint

  @doc """
  Returns the list of chatrooms.

  ## Examples

      iex> list_chatrooms()
      [%ChatRoom{}, ...]

  """
  def list_chatrooms do
    Repo.all(ChatRoom)
  end

  @doc """
  Gets a single chat_room.

  Raises `Ecto.NoResultsError` if the Chat room does not exist.

  ## Examples

      iex> get_chat_room!(123)
      %ChatRoom{}

      iex> get_chat_room!(456)
      ** (Ecto.NoResultsError)

  """
  def get_chat_room!(id), do: Repo.get!(ChatRoom, id)

  @doc """
  Creates a chat_room.

  ## Examples

      iex> create_chat_room(%{field: value})
      {:ok, %ChatRoom{}}

      iex> create_chat_room(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_chat_room(attrs \\ %{}) do
    %ChatRoom{}
    |> ChatRoom.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a chat_room.

  ## Examples

      iex> update_chat_room(chat_room, %{field: new_value})
      {:ok, %ChatRoom{}}

      iex> update_chat_room(chat_room, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_chat_room(%ChatRoom{} = chat_room, attrs) do
    chat_room
    |> ChatRoom.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a chat_room.

  ## Examples

      iex> delete_chat_room(chat_room)
      {:ok, %ChatRoom{}}

      iex> delete_chat_room(chat_room)
      {:error, %Ecto.Changeset{}}

  """
  def delete_chat_room(%ChatRoom{} = chat_room) do
    Repo.delete(chat_room)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking chat_room changes.

  ## Examples

      iex> change_chat_room(chat_room)
      %Ecto.Changeset{data: %ChatRoom{}}

  """
  def change_chat_room(%ChatRoom{} = chat_room, attrs \\ %{}) do
    ChatRoom.changeset(chat_room, attrs)
  end

  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end

  def get_messages_for_room(chat_room_id) do
    Message.Query.for_room(chat_room_id)
    |> Repo.all()
    |> Repo.preload(:sender)
  end

  def get_previous_n_messages(id, chat_room_id, n) do
    Message.Query.previous_n(id, chat_room_id, n)
    |> Repo.all()
    |> Repo.preload(:sender)
  end

  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
    |> publish_message_created()
  end

  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
    |> publish_message_updated()
  end

  def preload_message_sender(message) do
    message
    |> Repo.preload(:sender)
  end

  def publish_message_created({:ok, message} = result) do
    Endpoint.broadcast("room:#{message.chat_room_id}", "new_message", %{message: message})
    result
  end

  def publish_message_created(result), do: result

  def publish_message_updated({:ok, message} = result) do
    Endpoint.broadcast("room:#{message.chat_room_id}", "updated_message", %{message: message})
    result
  end

  def publish_message_updated(result), do: result
end
