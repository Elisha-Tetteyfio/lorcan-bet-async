defmodule Lorcan do
  @moduledoc """
  Documentation for `Lorcan`.
  """
  use Plug.Router

  plug :match
  plug :dispatch

  def hello do
    :world
  end

  get "/" do
    send_resp(conn, 200, "Welcome to My API!")
  end
end
