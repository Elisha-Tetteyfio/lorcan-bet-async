defmodule Lorcan.OrderConsumer do
  use GenStage
  alias Lorcan.Schema.OrderLog
  alias Lorcan.Schema.Inventory
  alias Lorcan.Repo

  def start_link(_) do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:consumer, :ok}
  end

  def handle_events(orders, _from, state) do
    Enum.each(orders, &process_order/1)
    {:noreply, [], state}
  end

  defp process_order(order) do
    Repo.transaction(fn ->
      inventory = Repo.get_by(Inventory, product_id: order.product_id)

      if inventory.quantity >= order.quantity do
        new_quantity = inventory.quantity - order.quantity
        Repo.update!(Ecto.Changeset.change(inventory, quantity: new_quantity))

        case call_payment_service(order) do
          :ok ->
            Repo.update!(Ecto.Changeset.change(order, status: "processed"))
            Repo.insert!(%OrderLog{order_id: order.id, status: "processed"})
          :error ->
            Repo.update!(Ecto.Changeset.change(order, status: "failed"))
            Repo.insert!(%OrderLog{order_id: order.id, status: "failed", error_message: "External payment failed"})
        end
      else
        Repo.update!(Ecto.Changeset.change(order, status: "failed"))
        Repo.insert!(%OrderLog{order_id: order.id, status: "failed", error_message: "Order quantity more than inventory"})
      end
    end)
  end

  defp call_payment_service(_order) do
    if :rand.uniform() > 0.8 do
      :error
    else
      :ok
    end
  end
end
