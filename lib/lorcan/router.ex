defmodule Lorcan.Router do
  alias Lorcan.Controller.ProductController
  # alias Lorcan.Schema.Product
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "Welcome to Orders API!")
  end

  # Create a new order
  post "/products" do
    {:ok, body, conn} = read_body(conn)
    {:ok, parsed} = Poison.decode(body)

    product = %{
      name: parsed["name"],
      price: parsed["price"],
      description: parsed["description"]
    }
    inventory = %{
      quantity: parsed["quantity"]
    }

    case ProductController.create_product(product, inventory) do
      {:ok, message} ->
        send_response(conn, 200, message)
      {:error, reason} ->
        send_response(conn, 400, reason)
    end
  end

  def send_response(conn, request_status, response) do
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(request_status, Poison.encode!(response))
  end
end
