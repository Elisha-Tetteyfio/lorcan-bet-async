defmodule Lorcan.Controller.ProductController do
  import Ecto.Query
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
              product_details(product, inventory)
            {:error, changeset} ->
              Repo.rollback(changeset)
          end

        {:error, changeset} ->
          Repo.rollback(changeset)
      end
    end)
  end

  defp product_details(product, inventory) do
    name = product.name
    price = product.price
    quantity = inventory.quantity
    description = product.description

    Map.put(Constants.success_created, :details, %{name: name, price: price, quantity: quantity, description: description})
  end

  defp product_details(product) do
    name = product.name
    price = product.price
    description = product.description

    Map.put(Constants.success_updated, :details, %{name: name, price: price, description: description})
  end


  def get_products do
    case Repo.all(
      from(p in Product,
						left_join: i in Inventory, on: i.product_id == p.id,
						select: %{id: p.id, name: p.name, price: p.price, quantity: i.quantity}
					)
    ) do
      [] ->
        {:error, Constants.no_record_found}
      products ->
        {:ok, Map.put(Constants.success, :details, products)}
    end
  end

  def update_product(product_id, details) do
    case Repo.get(Product, product_id) do
      nil ->
        {:error, Constants.no_record_found}

      product ->
        # inventory = Repo.preload(product, :inventory)

        changeset = Product.changeset(product, details)

        case Repo.update(changeset) do
          {:ok, updated_product} ->
            {:ok, product_details(updated_product)}

          {:error, changeset} ->
            {:error, changeset}
        end
    end
  end
end
