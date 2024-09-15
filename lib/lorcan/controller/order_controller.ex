defmodule Lorcan.Controller.OrderController do
  alias Lorcan.Schema.Order
  alias Lorcan.Schema.Product
  alias Lorcan.Constants
  alias Lorcan.Repo

  def create_order(details) do
    case validate_product(details.product_id) do
      {:ok} ->
        order_changeset = Order.changeset(%Order{}, Map.put(details, :status, "pending"))
        case Repo.insert(order_changeset) do
          {:ok, order} ->
            {:ok, order_details(order)}
          {:error, changeset} ->
            {:error, changeset}
        end
      {:error, reason} ->
        {:error, reason}
    end
  end

  defp order_details(order) do
    quantity = order.quantity
    status = order.status
    product_id = order.product_id

    Map.put(Constants.success_created, :details, %{quantity: quantity, status: status, product_id: product_id})
  end

  def validate_product(product_id) do
    case Repo.get(Product, product_id) do
      nil ->
        {:error, Constants.no_record_found}
      _ ->
        {:ok}
      end
  end
end
