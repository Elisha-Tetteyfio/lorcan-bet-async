defmodule Lorcan.Schema.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field(:quantity, :integer)
    field(:status, :string)
    belongs_to(:product, Lorcan.Schema.Product)
    timestamps()
  end

  def changeset(order, attrs) do
    order
    |> cast(attrs, [:quantity, :status, :product_id])
    |> validate_required([:quantity, :status, :product_id])
  end
end
