defmodule Lorcan.OrderProducer do
  import Ecto.Query
  alias Lorcan.Schema.Order
  alias Lorcan.Repo
  use GenStage

  def start_link(_) do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:producer, []}
  end

  def handle_demand(demand, state) do
    orders = Repo.all(from o in Order, where: o.status == "pending", limit: ^demand)
    {:noreply, orders, state}
  end
end
