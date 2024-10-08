defmodule Lorcan.Macro do
  defmacro const(name, value) do
    quote do
      @doc "Constant #{unquote(name)}"
      def unquote(:"#{name}")(), do: unquote(value)
    end
  end
end



defmodule Lorcan.Constants do
  import Lorcan.Macro

  # Validation error messages
  const :err_missing_name, %{ resp_code: "450", resp_msg: "Missing name in params" }
  const :err_invalid_name, %{ resp_code: "451", resp_msg: "Invalid name" }
  const :err_missing_price, %{ resp_code: "452", resp_msg: "Missing price in params" }
  const :err_invalid_price, %{ resp_code: "453", resp_msg: "Invalid price value" }
  const :err_missing_quantity, %{ resp_code: "454", resp_msg: "Missing quantity in params" }
  const :err_invalid_quantity, %{ resp_code: "456", resp_msg: "Invalid quantity value" }
  const :err_missing_id, %{ resp_code: "457", resp_msg: "Missing id in params" }
  const :err_invalid_id, %{ resp_code: "458", resp_msg: "Invalid id value" }

  # Success messages
  const :success_created, %{ resp_code: "00", resp_msg: "Product successfully created" }
  const :success_updated, %{ resp_code: "00", resp_msg: "Product successfully updated" }
  const :success_deleted, %{ resp_code: "00", resp_msg: "Product successfully deleted" }
  const :success, %{ resp_code: "00", resp_msg: "Success" }

  # Other messages
  const :no_record_found, %{resp_code: "404", resp_msg: "No records found"}
end
