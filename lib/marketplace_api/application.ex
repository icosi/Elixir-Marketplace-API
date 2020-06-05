defmodule MarketplaceApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias MarketplaceApi.Repo

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: MarketplaceApi.Worker.start_link(arg)
      # {MarketplaceApi.Worker, arg}
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: MarketplaceApi.Endpoint,
        options: [port: Application.get_env(:marketplace_api, :port)]
      ),
      Repo
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MarketplaceApi.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
