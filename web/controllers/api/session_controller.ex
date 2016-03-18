defmodule Finances.API.SessionController do
  use Finances.Web, :controller
  alias Finances.Session
  alias Finances.Registration

  def valid(conn, params) do
    session = case Map.fetch(params, "token") do
      {:ok, token} -> Repo.get_by(Session, %{token: token})
      :error -> nil
    end

    render conn, session: session
  end

  def create(conn, params) do
    %{"email" => email, "password" => password} =
      Map.take(params, ["email", "password"])

    case Registration.valid?(email, password) do
      {:ok, user} ->
        case Session.find_or_create_for(user) do
          {:ok, session} ->
            conn
            |> put_status(:created)
            |> render(session: session)
          {:error, _changeset} -> render(conn, session: nil)
        end
      :invalid -> render(conn, session: nil)
    end
  end
end
