defmodule LiveViewAppsWeb.VolunteersLive do
  use LiveViewAppsWeb, :live_view

  alias LiveViewApps.Volunteers

  def mount(_params, _session, socket) do
    volunteers = Volunteers.list_volunteers()
    changeset = Volunteers.change_volunteer(%Volunteers.Volunteer{})
    form = to_form(changeset)

    socket =
      socket
      |> stream(:volunteers, volunteers)
      |> assign(:form, form)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Volunteer Check-In</h1>
    <div id="volunteer-checkin">
      <.form for={@form} phx-submit="save" phx-change="validate">
        <.input
          field={@form[:name]}
          placeholder="Your name here..."
          autocomplete="off"
          phx-debounce="2000"
        />
        <.input
          type="tel"
          field={@form[:phone]}
          placeholder="434-23-31"
          autocomplete="off"
          phx-debounce="blur"
        />
        <.button phx-disable-with="Submitting...">Check In</.button>
      </.form>
      <div id="volunteers" phx-update="stream">
        <div
          :for={{volunteer_id, volunteer} <- @streams.volunteers}
          class={"volunteer #{if volunteer.checked_out, do: "out"}"}
          id={volunteer_id}
        >
          <div class="name">
            <%= volunteer.name %>
          </div>
          <div class="phone">
            <%= volunteer.phone %>
          </div>
          <div class="status">
            <button>
              <%= if volunteer.checked_out,
                do: "Check In",
                else: "Check Out" %>
            </button>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("validate", %{"volunteer" => volunteer_params}, socket) do
    changeset =
      %Volunteers.Volunteer{}
      |> Volunteers.change_volunteer(volunteer_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("save", %{"volunteer" => volunteer_params}, socket) do
    case Volunteers.create_volunteer(volunteer_params) do
      {:ok, volunteer} ->
        changeset = Volunteers.change_volunteer(%Volunteers.Volunteer{})

        socket =
          socket
          |> stream_insert(:volunteers, volunteer, at: 0)
          |> assign(form: to_form(changeset))

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
