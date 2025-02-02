defmodule Htzn.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      HtznWeb.Telemetry,
      Htzn.Repo,
      {DNSCluster, query: Application.get_env(:htzn, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Htzn.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Htzn.Finch},
      # Start a worker by calling: Htzn.Worker.start_link(arg)
      # {Htzn.Worker, arg},
      # Start to serve requests, typically the last entry
      HtznWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Htzn.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HtznWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
