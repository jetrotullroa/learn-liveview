defmodule LiveViewAppsWeb.SalesLive do
  use LiveViewAppsWeb, :live_view

  alias LiveViewApps.Sales

  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(1200, self(), "realtime")
    end

    {:ok, assign_values(socket)}
  end

  def render(assigns) do
    ~H"""
    <h1>Snappy Sales 📊</h1>
    <div id="sales">
      <div class="stats">
        <div class="stat">
          <span class="value">
            <%= @new_orders %>
          </span>
          <span class="label">
            New Orders
          </span>
        </div>
        <div class="stat">
          <span class="value">
            $<%= @sales_amount %>
          </span>
          <span class="label">
            Sales Amount
          </span>
        </div>
        <div class="stat">
          <span class="value">
            <%= @satisfaction %>%
          </span>
          <span class="label">
            Satisfaction
          </span>
        </div>
      </div>

      <button phx-click="refresh">
        <img src="/images/refresh.svg" /> Refresh
      </button>
    </div>
    """
  end

  def handle_event("refresh", _unsigned_params, socket), do: {:noreply, assign_values(socket)}

  def handle_info("realtime", socket), do: {:noreply, assign_values(socket)}

  def assign_values(socket) do
    assign(socket,
      new_orders: Sales.new_orders(),
      sales_amount: Sales.sales_amount(),
      satisfaction: Sales.satisfaction()
    )
  end
end
