defmodule Lorcan.Schema.OrderLog do
  use Ecto.Schema
  import Ecto.Changeset

  schema "order_logs" do
    field(:status, :string)
    field(:processed_at, :string)
    field(:error_message, :string)
    belongs_to(:order, Lorcan.Schema.Order)
    timestamps()
  end

  def changeset(order_log, attrs) do
    order_log
    |> cast(attrs, [:status, :processed_at, :error_message, :order_id])
    |> validate_required([:status, :order_id])
  end
end
