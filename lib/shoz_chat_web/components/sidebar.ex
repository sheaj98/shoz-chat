defmodule ShozChatWeb.Sidebar do
  use Phoenix.Component
  use ShozChatWeb, :verified_routes
  import ShozChatWeb.CoreComponents
  alias Phoenix.LiveView.JS

  def sidebar(assigns) do
    ~H"""
    <aside>
      <div
        id="mobile-sidebar-container"
        class="fixed inset-0 flex z-40 lg:hidden"
        aria-modal="true"
        style="display: none;"
        role="region"
      >
        <div class="fixed inset-0 bg-gray-600 bg-opacity-75" phx-click={hide_mobile_sidebar()}></div>

        <div
          id="mobile-sidebar"
          class="relative flex-1 flex flex-col max-w-xs w-full pt-5 pb-4 bg-white  min-h-screen"
        >
          <div class="absolute top-0 right-0 -mr-12 pt-2">
            <button
              type="button"
              id="hide-mobile-sidebar"
              aria-expanded="true"
              aria-controls="mobile-sidebar"
              class="ml-1 flex items-center justify-center h-10 w-10 rounded-full focus:outline-none focus:ring-2 focus:ring-inset focus:ring-white"
              phx-click={hide_mobile_sidebar()}
            >
              <span class="sr-only">Close sidebar</span>
              <svg
                class="h-6 w-6 text-white"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
                aria-hidden="true"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M6 18L18 6M6 6l12 12"
                >
                </path>
              </svg>
            </button>
          </div>

          <div class="flex-shrink-0 flex items-center px-4">
            <.link href={~p"/"}>
              <span class="h-8 w-auto text-2xl ml-1 font-bold">
                ShozChat
              </span>
            </.link>
          </div>
          <div class="mt-5 flex-1 h-0 overflow-y-auto">
            <nav class="px-2">
              <p>Chat Rooms</p>
            </nav>
          </div>
        </div>

        <div class="flex-shrink-0 w-14" aria-hidden="true">
          <!-- Dummy element to force sidebar to shrink to fit close icon -->
        </div>
      </div>
      <!-- Static sidebar for desktop -->
      <div class="hidden h-full lg:flex lg:flex-shrink-0" role="region">
        <div class="flex flex-col w-64 border-r border-gray-200 pt-5 pb-4 bg-gray-700">
          <div class="flex justify-between items-center flex-shrink-0 px-6">
            <.link navigate={~p"/"}>
              <span class="h-8 w-auto text-2xl font-bold text-neutral-100">
                ShozChat
              </span>
            </.link>
          </div>
          <!-- Sidebar component, swap this element with another sidebar if you like -->
          <div class="h-0 flex-1 flex flex-col overflow-y-auto">
            <!-- Navigation -->
            <nav class="px-3 mt-6">
              <div class="flex justify-between align-middle ">
                <h3 class="px-3 text-xs font-semibold text-gray-400 uppercase tracking-wider">
                  Channels
                </h3>
                <a
                  href={
                    if @active_tab != nil,
                      do: "/chatrooms/#{@active_tab}/new",
                      else: "/chatrooms/new"
                  }
                  id="add-new-chatroom"
                  class=" flex items-center justify-center h-5 w-5"
                >
                  <span class="sr-only">Close sidebar</span>
                  <.icon name="hero-plus" class="text-neutral-400 hover:text-neutral-100" />
                </a>
              </div>
              <div id="chatrooms" class="px-3 flex flex-col gap-2" phx-update="stream">
                <%= for {id, chatroom} <- @chatrooms do %>
                  <a
                    class={"cursor-pointer #{if @active_tab == Integer.to_string(chatroom.id), do: "text-neutral-100 font-semibold", else: "text-neutral-300 hover:text-neutral-100"}"}
                    id={id}
                    class="name"
                    href={~p"/chatrooms/#{chatroom.id}"}
                    aria-current={
                      if @active_tab == Integer.to_string(chatroom.id), do: "true", else: "false"
                    }
                  >
                    # <%= chatroom.name %>
                  </a>
                <% end %>
              </div>
            </nav>
          </div>
        </div>
      </div>
      <!-- Main column -->
      <div class="flex flex-col w-0 flex-1 overflow-hidden">
        <!-- Search header -->
        <div
          class="relative z-10 flex-shrink-0 flex h-16 bg-white border-b border-gray-200 lg:hidden"
          role="navigation"
        >
          <button
            type="button"
            id="show-mobile-sidebar"
            aria-expanded="false"
            aria-controls="mobile-sidebar"
            class="px-4 border-r h-5 w-5 border-gray-200 text-gray-500 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-purple-500 lg:hidden"
            phx-click={show_mobile_sidebar()}
          >
            <span class="sr-only">Open sidebar</span>
            <svg
              class="h-6 w-6"
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
              aria-hidden="true"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M4 6h16M4 12h8m-8 6h16"
              >
              </path>
            </svg>
          </button>
        </div>
      </div>
    </aside>
    """
  end

  def show_mobile_sidebar(js \\ %JS{}) do
    js
    |> JS.show(to: "#mobile-sidebar-container", transition: "fade-in")
    |> JS.show(
      to: "#mobile-sidebar",
      display: "flex",
      time: 300,
      transition:
        {"transition ease-in-out duration-300 transform", "-translate-x-full", "translate-x-0"}
    )
    |> JS.hide(to: "#show-mobile-sidebar", transition: "fade-out")
    |> JS.dispatch("js:exec", to: "#hide-mobile-sidebar", detail: %{call: "focus", args: []})
  end

  def hide_mobile_sidebar(js \\ %JS{}) do
    js
    |> JS.hide(to: "#mobile-sidebar-container", transition: "fade-out")
    |> JS.hide(
      to: "#mobile-sidebar",
      time: 300,
      transition:
        {"transition ease-in-out duration-300 transform", "translate-x-0", "-translate-x-full"}
    )
    |> JS.show(to: "#show-mobile-sidebar", transition: "fade-in")
    |> JS.dispatch("js:exec", to: "#show-mobile-sidebar", detail: %{call: "focus", args: []})
  end
end
