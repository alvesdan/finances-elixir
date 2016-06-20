defmodule Finances.HTMLController do
  import Plug.Conn

  def add_body_class(conn, name) do
    Plug.Conn.put_private(conn, :body_class, name)
  end
end
