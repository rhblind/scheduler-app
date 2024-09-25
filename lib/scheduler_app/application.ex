defmodule SchedulerApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SchedulerAppWeb.Telemetry,
      SchedulerApp.Repo,
      {DNSCluster, query: Application.get_env(:scheduler_app, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: SchedulerApp.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: SchedulerApp.Finch},
      # Start a worker by calling: SchedulerApp.Worker.start_link(arg)
      # {SchedulerApp.Worker, arg},
      # Start to serve requests, typically the last entry

      # Oban
      {Oban,
       AshOban.config([SchedulerApp.Domain.Oban], Application.fetch_env!(:scheduler_app, Oban))},

      # Finally start Endpoint
      SchedulerAppWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SchedulerApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SchedulerAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
