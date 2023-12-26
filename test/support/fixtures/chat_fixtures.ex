defmodule ShozChat.ChatFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ShozChat.Chat` context.
  """

  @doc """
  Generate a chat_room.
  """
  def chat_room_fixture(attrs \\ %{}) do
    {:ok, chat_room} =
      attrs
      |> Enum.into(%{
        description: "some description",
        id: "some id",
        name: "some name"
      })
      |> ShozChat.Chat.create_chat_room()

    chat_room
  end
end
