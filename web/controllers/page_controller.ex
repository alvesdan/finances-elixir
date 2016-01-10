defmodule Finances.PageController do
  use Finances.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
