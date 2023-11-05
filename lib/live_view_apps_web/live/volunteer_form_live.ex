defmodule LiveViewAppsWeb.VolunteerFormLive do
  use LiveViewAppsWeb, :live_component

  alias LiveViewApps.Volunteers
  alias LiveViewApps.Volunteers.Volunteer

  def mount(socket) do
    changeset = Volunteers.change_volunteer(%Volunteer{})
    form = to_form(changeset)

    {:ok, assign(socket, form: form)}
  end

  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign(count: assigns.count + 1)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <div class="count">
        <h3>Volunteer #<%= @count %></h3>
      </div>

      <.form
        for={@form}
        phx-submit="save"
        phx-change="validate"
        phx-target={@myself}
      >
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
    </div>
    """
  end

  def handle_event("validate", %{"volunteer" => volunteer_params}, socket) do
    changeset =
      %Volunteer{}
      |> Volunteers.change_volunteer(volunteer_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("save", %{"volunteer" => volunteer_params}, socket) do
    case Volunteers.create_volunteer(volunteer_params) do
      {:ok, volunteer} ->
        send(self(), {:volunteer_created, volunteer})
        {:noreply, assign(socket, form: to_form(Volunteers.change_volunteer(%Volunteer{})))}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
