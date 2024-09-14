defmodule Lorcan.Repo.Migrations.CreateInventory do
  use Ecto.Migration

  def change do
    create table(:inventory) do
      add :product_id, references(:products, on_delete: :delete_all), null: false
      add :quantity, :integer, null: false
      timestamps()
    end
  end
end
