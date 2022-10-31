defmodule Bookshare.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Bookshare.Repo,
      # Start the Telemetry supervisor
      BookshareWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Bookshare.PubSub},
      # Start the Endpoint (http/https)
      BookshareWeb.Endpoint
      # Start a worker by calling: Bookshare.Worker.start_link(arg)
      # {Bookshare.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bookshare.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BookshareWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
