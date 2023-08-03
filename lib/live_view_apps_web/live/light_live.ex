defmodule LiveViewAppsWeb.LightLive do
  use LiveViewAppsWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, brightness: 10)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Front Patio Light</h1>
    <div id="light">
      <div class="meter">
        <span style={"width: #{@brightness}%"}><%= @brightness %></span>
      </div>
      <button phx-click="off">
        <img src="/images/light-off.svg" alt="light-off" />
      </button>
      <button phx-click="down">
        <img src="/images/down.svg" alt="light-down" />
      </button>
      <button phx-click="up">
        <img src="/images/up.svg" alt="light-up" />
      </button>
      <button phx-click="on">
        <img src="/images/light-on.svg" alt="light-on" />
      </button>
    </div>
    """
  end

  def handle_event("on", _payload, socket) do
    socket = assign(socket, brightness: 100)
    {:noreply, socket}
  end

  def handle_event("off", _payload, socket) do
    socket = assign(socket, brightness: 0)
    {:noreply, socket}
  end

  def handle_event("down", _payload, socket) do
    socket = update(socket, :brightness, &max(0, &1 - 10))
    {:noreply, socket}
  end

  def handle_event("up", _payload, socket) do
    socket = update(socket, :brightness, &min(100, &1 + 10))
    {:noreply, socket}
  end
end
