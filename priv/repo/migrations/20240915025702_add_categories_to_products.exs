defmodule Lorcan.Repo.Migrations.AddCategoriesToProducts do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string
      timestamps()
    end

    create table(:product_categories) do
      add :product_id, references(:products, on_delete: :delete_all)
      add :category_id, references(:categories, on_delete: :delete_all)
      timestamps()
    end
  end
end
