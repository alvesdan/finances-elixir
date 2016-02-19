defmodule Finances.API.SessionController do
  use Finances.Web, :controller
  alias Finances.User

  def valid(conn, _params) do
    render conn, user: %User{}
  end
end
