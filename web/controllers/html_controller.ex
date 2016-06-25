defmodule Finances.HTMLController do
  def add_body_class(conn, name) do
    Plug.Conn.put_private(conn, :body_class, name)
  end
end
