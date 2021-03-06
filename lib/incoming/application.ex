defmodule Incoming.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Incoming.Repo,
      # Start the Telemetry supervisor
      IncomingWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Incoming.PubSub},
      # Start the Endpoint (http/https)
      IncomingWeb.Endpoint,
      # Start a dialer
      {Incoming.Shifter, name: :shifter}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Incoming.Supervisor]
    Supervisor.start_link(children, opts)

    IncomingDialer.start_link(
      %{url_base: "https://nameless-forest-48275.herokuapp.com/api/hooks"},
      name: :dialer
    )
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    IncomingWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
