defmodule LiveViewAppsWeb.DonationsLive do
  use LiveViewAppsWeb, :live_view

  import LiveViewApps.Donations, only: [list_donations: 1, count_donations: 0]

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    sort_by = (params["sort_by"] || "id") |> String.to_atom()
    sort_order = (params["sort_order"] || "asc") |> String.to_atom()
    page = (params["page"] || "1") |> String.to_integer()
    per_page = (params["per_page"] || "5") |> String.to_integer()

    options = %{sort_by: sort_by, sort_order: sort_order, page: page, per_page: per_page}
    donations = list_donations(options)

    socket = assign(socket, donations: donations, options: options)

    {:noreply, socket}
  end

  def handle_event("select-per-page", %{"per-page" => per_page}, socket) do
    params = %{socket.assigns.options | per_page: per_page}
    socket = push_patch(socket, to: ~p"/donations?#{params}")

    {:noreply, socket}
  end

  defp sort_item_link(assigns) do
    params = %{
      assigns.options
      | sort_by: assigns.sort_by,
        sort_order: next_sort_order(assigns.options.sort_order)
    }

    assigns = assign(assigns, params: params)

    ~H"""
    <.link patch={~p"/donations?#{@params}"}>
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end

  defp next_sort_order(sort_order) do
    case sort_order do
      :asc -> :desc
      :desc -> :asc
    end
  end

  defp is_max_donations?(options) do
    options.page <
      count_donations() / options.per_page
  end
end
