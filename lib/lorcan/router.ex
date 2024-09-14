defmodule Lorcan.Router do
  alias Lorcan.Validation
  alias Lorcan.Controller.ProductController
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

    with {:ok, _name} <- Validation.validate_name(parsed["name"]),
      {:ok, _price} <- Validation.validate_price(parsed["price"]),
      {:ok, _quantity} <- Validation.validate_quantity(parsed["quantity"])
      do
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
    else
      {:error, reason} ->
        send_response(conn, 400, reason)
      end
  end

  get "/products" do
    case ProductController.get_products do
      {:ok, response} ->
        send_response(conn, 200, response)
      {:error, reason} ->
        send_response(conn, 404, reason)
    end
  end

  put "/product/:id" do
    product_id = conn.params["id"]
    case Validation.validate_id(product_id) do
      {:ok, _} ->
        {:ok, body, conn} = read_body(conn)
        {:ok, details} = Poison.decode(body)

        case ProductController.update_product(product_id, details) do
          {:ok, message} ->
            send_response(conn, 200, message)
          {:error, reason} ->
            send_response(conn, 404, reason)
        end
      {:error, reason} ->
        send_response(conn, 400, reason)
    end
  end

  delete "product/:id" do
    product_id = conn.params["id"]
    case Validation.validate_id(product_id) do
      {:ok, _} ->
        case ProductController.delete_product(product_id) do
          {:ok, message} ->
            send_response(conn, 200, message)
          {:error, reason} ->
            send_response(conn, 400, reason)
        end
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
