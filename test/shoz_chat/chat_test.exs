defmodule ShozChat.ChatTest do
  use ShozChat.DataCase

  alias ShozChat.Chat

  describe "chatrooms" do
    alias ShozChat.Chat.ChatRoom

    import ShozChat.ChatFixtures

    @invalid_attrs %{id: nil, name: nil, description: nil}

    test "list_chatrooms/0 returns all chatrooms" do
      chat_room = chat_room_fixture()
      assert Chat.list_chatrooms() == [chat_room]
    end

    test "get_chat_room!/1 returns the chat_room with given id" do
      chat_room = chat_room_fixture()
      assert Chat.get_chat_room!(chat_room.id) == chat_room
    end

    test "create_chat_room/1 with valid data creates a chat_room" do
      valid_attrs = %{id: "some id", name: "some name", description: "some description"}

      assert {:ok, %ChatRoom{} = chat_room} = Chat.create_chat_room(valid_attrs)
      assert chat_room.id == "some id"
      assert chat_room.name == "some name"
      assert chat_room.description == "some description"
    end

    test "create_chat_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chat.create_chat_room(@invalid_attrs)
    end

    test "update_chat_room/2 with valid data updates the chat_room" do
      chat_room = chat_room_fixture()
      update_attrs = %{id: "some updated id", name: "some updated name", description: "some updated description"}

      assert {:ok, %ChatRoom{} = chat_room} = Chat.update_chat_room(chat_room, update_attrs)
      assert chat_room.id == "some updated id"
      assert chat_room.name == "some updated name"
      assert chat_room.description == "some updated description"
    end

    test "update_chat_room/2 with invalid data returns error changeset" do
      chat_room = chat_room_fixture()
      assert {:error, %Ecto.Changeset{}} = Chat.update_chat_room(chat_room, @invalid_attrs)
      assert chat_room == Chat.get_chat_room!(chat_room.id)
    end

    test "delete_chat_room/1 deletes the chat_room" do
      chat_room = chat_room_fixture()
      assert {:ok, %ChatRoom{}} = Chat.delete_chat_room(chat_room)
      assert_raise Ecto.NoResultsError, fn -> Chat.get_chat_room!(chat_room.id) end
    end

    test "change_chat_room/1 returns a chat_room changeset" do
      chat_room = chat_room_fixture()
      assert %Ecto.Changeset{} = Chat.change_chat_room(chat_room)
    end
  end
end
