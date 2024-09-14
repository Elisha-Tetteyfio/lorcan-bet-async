defmodule Lorcan.Schema.Inventory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "inventory" do
    field(:quantity, :integer)
    belongs_to(:product, Lorcan.Schema.Product)
    timestamps()
  end

  def changeset(inventory, attrs) do
    inventory
    |> cast(attrs, [:quantity, :product_id])
    |> validate_required([:quantity, :product_id])
  end
end
