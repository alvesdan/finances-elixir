defmodule Finances.PageController do
  use Finances.Web, :controller
  import Finances.HTMLController

  def index(conn, _params) do
    conn
    |> add_body_class("home")
    |> render("index.html")
  end
end
