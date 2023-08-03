defmodule LiveViewAppsWeb.PizzaOrdersLive do
  use LiveViewAppsWeb, :live_view

  alias LiveViewApps.PizzaOrders
  import Number.Currency

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        pizza_orders: PizzaOrders.list_pizza_orders()
      )

    {:ok, socket}
  end
end
