defmodule LiveViewApps.Repo do
  use Ecto.Repo,
    otp_app: :live_view_apps,
    adapter: Ecto.Adapters.Postgres
end
