defmodule ShozChatWeb.ChatRoomLiveTest do
  use ShozChatWeb.ConnCase

  import Phoenix.LiveViewTest
  import ShozChat.ChatFixtures

  @create_attrs %{id: "some id", name: "some name", description: "some description"}
  @update_attrs %{id: "some updated id", name: "some updated name", description: "some updated description"}
  @invalid_attrs %{id: nil, name: nil, description: nil}

  defp create_chat_room(_) do
    chat_room = chat_room_fixture()
    %{chat_room: chat_room}
  end

  describe "Index" do
    setup [:create_chat_room]

    test "lists all chatrooms", %{conn: conn, chat_room: chat_room} do
      {:ok, _index_live, html} = live(conn, ~p"/chatrooms")

      assert html =~ "Listing Chatrooms"
      assert html =~ chat_room.id
    end

    test "saves new chat_room", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/chatrooms")

      assert index_live |> element("a", "New Chat room") |> render_click() =~
               "New Chat room"

      assert_patch(index_live, ~p"/chatrooms/new")

      assert index_live
             |> form("#chat_room-form", chat_room: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#chat_room-form", chat_room: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/chatrooms")

      html = render(index_live)
      assert html =~ "Chat room created successfully"
      assert html =~ "some id"
    end

    test "updates chat_room in listing", %{conn: conn, chat_room: chat_room} do
      {:ok, index_live, _html} = live(conn, ~p"/chatrooms")

      assert index_live |> element("#chatrooms-#{chat_room.id} a", "Edit") |> render_click() =~
               "Edit Chat room"

      assert_patch(index_live, ~p"/chatrooms/#{chat_room}/edit")

      assert index_live
             |> form("#chat_room-form", chat_room: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#chat_room-form", chat_room: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/chatrooms")

      html = render(index_live)
      assert html =~ "Chat room updated successfully"
      assert html =~ "some updated id"
    end

    test "deletes chat_room in listing", %{conn: conn, chat_room: chat_room} do
      {:ok, index_live, _html} = live(conn, ~p"/chatrooms")

      assert index_live |> element("#chatrooms-#{chat_room.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#chatrooms-#{chat_room.id}")
    end
  end

  describe "Show" do
    setup [:create_chat_room]

    test "displays chat_room", %{conn: conn, chat_room: chat_room} do
      {:ok, _show_live, html} = live(conn, ~p"/chatrooms/#{chat_room}")

      assert html =~ "Show Chat room"
      assert html =~ chat_room.id
    end

    test "updates chat_room within modal", %{conn: conn, chat_room: chat_room} do
      {:ok, show_live, _html} = live(conn, ~p"/chatrooms/#{chat_room}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Chat room"

      assert_patch(show_live, ~p"/chatrooms/#{chat_room}/show/edit")

      assert show_live
             |> form("#chat_room-form", chat_room: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#chat_room-form", chat_room: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/chatrooms/#{chat_room}")

      html = render(show_live)
      assert html =~ "Chat room updated successfully"
      assert html =~ "some updated id"
    end
  end
end
