defmodule ShozChat.Chat.Message.Query do
  import Ecto.Query
  alias ShozChat.Chat.Message

  def base do
    Message
  end

  def for_room(query \\ base(), chat_room_id) do
    query
    |> where([m], m.chat_room_id == ^chat_room_id)
    |> order_by([m], {:desc, m.inserted_at})
    |> limit(10)
    |> subquery()
    |> order_by([m], {:asc, m.inserted_at})
  end

  def preload_sender do
    base()
    |> join(:inner, [m], s in assoc(m, :sender))
    |> order_by([m], {:desc, m.inserted_at})
    |> limit(10)
    |> preload([m, s], sender: s)
  end

  def previous_n(query \\ base(), id, chat_room_id, n) do
    query
    |> where([m], m.id < ^id)
    |> where([m], m.chat_room_id == ^chat_room_id)
    |> order_by([m], {:desc, m.inserted_at})
    |> limit(^n)
    |> order_by([m], {:asc, m.inserted_at})
  end
end
