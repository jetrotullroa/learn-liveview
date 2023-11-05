defmodule LiveViewAppsWeb.VolunteersLive do
  use LiveViewAppsWeb, :live_view

  alias LiveViewApps.Volunteers

  def mount(_params, _session, socket) do
    volunteers = Volunteers.list_volunteers()

    socket =
      socket
      |> stream(:volunteers, volunteers)
      |> assign(:count, length(volunteers))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Volunteer Check-In</h1>
    <div id="volunteer-checkin">
      <.live_component
        module={LiveViewAppsWeb.VolunteerFormLive}
        id={:new}
        count={@count}
      />
      <div id="volunteers" phx-update="stream">
        <.volunteer
          :for={{volunteer_id, volunteer} <- @streams.volunteers}
          volunteer={volunteer}
          id={volunteer_id}
        />
      </div>
    </div>
    """
  end

  def volunteer(assigns) do
    ~H"""
    <div
      class={"volunteer #{if @volunteer.checked_out, do: "out"}"}
      id={@id}
    >
      <div class="name">
        <%= @volunteer.name %>
      </div>
      <div class="phone">
        <%= @volunteer.phone %>
      </div>
      <div class="status">
        <button phx-click="toggle-status" phx-value-id={@volunteer.id}>
          <%= if @volunteer.checked_out,
            do: "Check In",
            else: "Check Out" %>
        </button>
      </div>
    </div>
    """
  end

  def handle_event("toggle-status", %{"id" => id}, socket) do
    volunteer = Volunteers.get_volunteer!(id)

    case Volunteers.update_volunteer(volunteer, %{checked_out: !volunteer.checked_out}) do
      {:ok, volunteer} ->
        {:noreply, stream_insert(socket, :volunteers, volunteer)}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_info({:volunteer_created, volunteer}, socket) do
    socket = assign(socket, count: socket.assigns.count + 1)
    {:noreply, stream_insert(socket, :volunteers, volunteer, at: 0)}
  end
end
