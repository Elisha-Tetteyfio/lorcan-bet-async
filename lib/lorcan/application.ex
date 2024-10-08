defmodule Lorcan.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Lorcan.Worker.start_link(arg)
      # {Lorcan.Worker, arg}
      Lorcan.Repo,
      {Plug.Cowboy, scheme: :http, plug: Lorcan.Router, options: [port: 4002]},
      {Lorcan.OrderProducer, []},
      {Lorcan.OrderConsumer, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Lorcan.Supervisor]
    {:ok, supervisor_pid} = Supervisor.start_link(children, opts)

    connect_producer_and_consumer()
    {:ok, supervisor_pid}
  end

  defp connect_producer_and_consumer do
    GenStage.sync_subscribe(Lorcan.OrderConsumer, to: Lorcan.OrderProducer)
  end
end
