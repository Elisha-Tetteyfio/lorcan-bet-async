defmodule Lorcan.Controller.ProductController do
  alias Lorcan.Constants
  alias Lorcan.Schema.Inventory
  alias Lorcan.Schema.Product
  alias Lorcan.Repo

  def create_product(product, inventory_attrs) do
    product_changeset = Product.changeset(%Product{}, product)

    Repo.transaction(fn ->
      case Repo.insert(product_changeset) do
        {:ok, product} ->
          inventory_changeset = Inventory.changeset(%Inventory{}, Map.put(inventory_attrs, :product_id, product.id))

          case Repo.insert(inventory_changeset) do
            {:ok, inventory} ->
              new_product_details(product, inventory)
            {:error, changeset} ->
              Repo.rollback(changeset)
          end

        {:error, changeset} ->
          Repo.rollback(changeset)
      end
    end)
  end

  defp new_product_details(product, inventory) do
    name = product.name
    price = product.price
    quantity = inventory.quantity
    description = product.description

    Map.put(Constants.success_created, :details, %{name: name, price: price, quantity: quantity, description: description})
  end
end
