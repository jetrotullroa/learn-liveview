defmodule LiveViewAppsWeb.BoatsLive do
  use LiveViewAppsWeb, :live_view

  alias LiveViewApps.Boats

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        filter: %{type: "", prices: []},
        boats: Boats.list_boats()
      )

    {:ok, socket, temporary_assigns: [boats: []]}
  end

  def render(assigns) do
    ~H"""
    <h1>Daily Boat Rentals</h1>
    <div id="boats">
      <.promo expiration={3}>
        <p>
          Save 25% on your first rental
        </p>
        <:legal>
          <Heroicons.exclamation_circle /> Limit 1 per party
        </:legal>
      </.promo>
      <form phx-change="filter">
        <div class="filters">
          <select name="type">
            <%= Phoenix.HTML.Form.options_for_select(
              type_options(),
              @filter.type
            ) %>
          </select>
          <div class="prices">
            <%= for price <- ["$", "$$", "$$$"] do %>
              <input
                type="checkbox"
                name="prices[]"
                value={price}
                id={price}
                checked={price in @filter.prices}
              />
              <label for={price}><%= price %></label>
            <% end %>
            <input type="hidden" name="prices[]" value="" />
          </div>
        </div>
      </form>
      <div class="boats">
        <div :for={boat <- @boats} class="boat">
          <img src={boat.image} />
          <div class="content">
            <div class="model">
              <%= boat.model %>
            </div>
            <div class="details">
              <span class="price">
                <%= boat.price %>
              </span>
              <span class="type">
                <%= boat.type %>
              </span>
            </div>
          </div>
        </div>
      </div>
      <.promo expiration={2}>
        <p>
          Save 25% on your first rental
        </p>
        <:legal>
          <Heroicons.exclamation_circle /> Limit 1 per party
        </:legal>
      </.promo>
    </div>
    """
  end

  def promo(assigns) do
    ~H"""
    <div class="promo">
      <div class="deal">
        <%= render_slot(@inner_block) %>
      </div>
      <div class="expiration">
        Deal expires on <%= @expiration %> hours!
      </div>
      <div class="legal">
        <%= render_slot(@legal) %>
      </div>
    </div>
    """
  end

  def handle_event("filter", %{"type" => type, "prices" => prices}, socket) do
    filter = %{type: type, prices: prices}
    boats = Boats.list_boats(filter)

    {:noreply, assign(socket, filter: filter, boats: boats)}
  end

  defp type_options do
    [
      "All Types": "",
      Fishing: "fishing",
      Sporting: "sporting",
      Sailing: "sailing"
    ]
  end
end
