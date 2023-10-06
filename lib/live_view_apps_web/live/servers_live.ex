defmodule LiveViewAppsWeb.ServersLive do
  use LiveViewAppsWeb, :live_view

  alias LiveViewApps.Servers

  def mount(_params, _session, socket) do
    servers = Servers.list_servers()

    socket =
      assign(socket,
        servers: servers,
        selected_server: hd(servers),
        coffees: 0
      )

    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _url, socket) do
    server = Servers.get_server!(String.to_integer(id))
    {:noreply, assign(socket, page_title: "What's up #{server.name}", selected_server: server)}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, assign(socket, selected_server: hd(socket.assigns.servers))}
  end

  def render(assigns) do
    ~H"""
    <h1>Servers<%= " - #{assigns.selected_server.name}" %></h1>
    <div id="servers">
      <div class="sidebar">
        <div class="nav">
          <.link
            :for={server <- @servers}
            patch={~p"/servers?#{[id: server.id]}"}
            class={if server == @selected_server, do: "selected"}
          >
            <span class={server.status}></span>
            <%= server.name %>
          </.link>
        </div>
        <div class="coffees">
          <button phx-click="drink">
            <img src="/images/coffee.svg" />
            <%= @coffees %>
          </button>
        </div>
      </div>
      <div class="main">
        <div class="wrapper">
          <div class="server">
            <div class="header">
              <h2><%= @selected_server.name %></h2>
              <span class={@selected_server.status}>
                <%= @selected_server.status %>
              </span>
            </div>
            <div class="body">
              <div class="row">
                <span>
                  <%= @selected_server.deploy_count %> deploys
                </span>
                <span>
                  <%= @selected_server.size %> MB
                </span>
                <span>
                  <%= @selected_server.framework %>
                </span>
              </div>
              <h3>Last Commit Message:</h3>
              <blockquote>
                <%= @selected_server.last_commit_message %>
              </blockquote>
            </div>
          </div>
          <div class="links">
            <.link navigate={~p"/light"}>Adjust Light</.link>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("drink", _, socket) do
    {:noreply, update(socket, :coffees, &(&1 + 1))}
  end
end
