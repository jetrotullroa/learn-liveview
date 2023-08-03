defmodule LiveViewAppsWeb.DonationsLive do
  use LiveViewAppsWeb, :live_view

  alias LiveViewApps.Donations

  def mount(_params, _session, socket) do
    donations = Donations.list_donations()

    socket =
      assign(socket,
        donations: donations
      )

    {:ok, socket}
  end
end
