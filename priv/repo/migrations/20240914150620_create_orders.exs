defmodule Lorcan.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :product_id, references(:products, on_delete: :delete_all), null: false
      add :quantity, :integer, null: false
      add :status, :string, default: "pending", null: false
      timestamps()
    end
  end
end
