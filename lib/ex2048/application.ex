defmodule Ex2048.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      Ex2048Web.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Ex2048.PubSub},
      # Start the Endpoint (http/https)
      Ex2048Web.Endpoint,
      # Start registry and supervisor for games
      {Registry, keys: :unique, name: Ex2048.GameRegistry},
      {DynamicSupervisor, strategy: :one_for_one, name: Ex2048.GameSupervisor}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ex2048.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Ex2048Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
