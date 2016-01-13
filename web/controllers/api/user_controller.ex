defmodule Finances.API.UserController do
  use Finances.Web, :controller
  alias Finances.User

  def index(conn, _params) do
    render conn, users: Repo.all(User)
  end
end
