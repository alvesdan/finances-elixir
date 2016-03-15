defmodule Finances.API.SessionController do
  use Finances.Web, :controller
  alias Finances.Session

  def valid(conn, params) do
    token = Map.get(params, "token")
    session = if token, do: Repo.get_by(Session, %{token: token}), else: nil
    render conn, session: session
  end
end
