defmodule Lorcan.Controller.ProductController do
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
              %{product: product, inventory: inventory}
            {:error, changeset} ->
              Repo.rollback(changeset)
          end

        {:error, changeset} ->
          Repo.rollback(changeset)
      end
    end)
  end
end
