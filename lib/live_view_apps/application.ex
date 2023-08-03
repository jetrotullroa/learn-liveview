defmodule LiveViewApps.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      LiveViewAppsWeb.Telemetry,
      # Start the Ecto repository
      LiveViewApps.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: LiveViewApps.PubSub},
      # Start Finch
      {Finch, name: LiveViewApps.Finch},
      # Start the Endpoint (http/https)
      LiveViewAppsWeb.Endpoint
      # Start a worker by calling: LiveViewApps.Worker.start_link(arg)
      # {LiveViewApps.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LiveViewApps.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LiveViewAppsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
