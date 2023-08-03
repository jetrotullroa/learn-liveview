defmodule LiveViewApps.ServersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveViewApps.Servers` context.
  """

  @doc """
  Generate a server.
  """
  def server_fixture(attrs \\ %{}) do
    {:ok, server} =
      attrs
      |> Enum.into(%{
        deploy_count: 42,
        framework: "some framework",
        last_commit_message: "some message",
        name: "some name",
        size: 120.5,
        status: "up"
      })
      |> LiveViewApps.Servers.create_server()

    server
  end
end
