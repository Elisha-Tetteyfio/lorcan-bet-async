defmodule Lorcan.OrderProducer do
  import Ecto.Query
  alias Lorcan.Schema.Order
  alias Lorcan.Repo
  use GenStage

  @poll_interval 60_000  # Run every 60 seconds

  def start_link(_) do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    :timer.send_interval(@poll_interval, :poll)
    {:producer, %{demand: 0, last_checked: NaiveDateTime.utc_now()}}
  end

  def handle_info(:poll, state) do
    # Fetch orders based on last checked time
    orders = fetch_orders(state.last_checked)
    new_state = %{state | last_checked: NaiveDateTime.utc_now()}
    {:noreply, orders, new_state}
  end

  defp fetch_orders(last_checked) do
    # Fetch orders created since the last check
    Repo.all(from o in Order, where: o.status == "pending" and o.inserted_at > ^last_checked)
  end

  def handle_demand(demand, state) do
    orders = Repo.all(from o in Order, where: o.status == "pending", limit: ^demand)
    {:noreply, orders, state}
  end
end
