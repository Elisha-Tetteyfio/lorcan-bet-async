defmodule Lorcan.Repo.Migrations.CreateOrderLogs do
  use Ecto.Migration

  def change do
    create table(:order_logs) do
      add :order_id, references(:orders, on_delete: :delete_all), null: false
      add :status, :string, null: false
      add :processed_at, :utc_datetime
      add :error_message, :text
      timestamps()
    end
  end
end
