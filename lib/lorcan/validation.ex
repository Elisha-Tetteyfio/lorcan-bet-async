defmodule Lorcan.Validation do
alias Lorcan.Constants

  def validate_name(name) when name in ["", nil], do: {:error, Constants.err_missing_name}
  def validate_name(name) do
    case is_binary(name) do
      true ->
        {:ok, String.trim(name)}
      false ->
        {:error, Constants.err_invalid_name}
    end
  end

  def validate_price(price) when price in ["", nil], do: {:error, Constants.err_missing_price}
  def validate_price(price) do
    case price do
      price when is_float(price) or is_integer(price) ->
      {:ok, price}
    _ ->
      {:error, Constants.err_invalid_price}
    end
  end

  def validate_quantity(quantity) when quantity in ["", nil], do: {:error, Constants.err_missing_quantity}
  def validate_quantity(quantity) do
    case quantity do
      quantity when is_integer(quantity) ->
      {:ok, quantity}
    _ ->
      {:error, Constants.err_invalid_quantity}
    end
  end

  def validate_id(val) when val in ["", nil], do: {:error, Constants.err_missing_id}
  def validate_id(val) do
    case Integer.parse(val) do
      {val, ""} ->
        {:ok, val}
      _error ->
        {:error, Constants.err_invalid_id}
    end
  end
end
