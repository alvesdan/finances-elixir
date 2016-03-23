defmodule Finances.API.SessionController do
  use Finances.Web, :controller
  alias Finances.Session
  alias Finances.Registration

  plug :validate_create_params when action in [:create]

  def valid(conn, params) do
    session = case Map.fetch(params, "token") do
      {:ok, token} -> Repo.get_by(Session, %{token: token})
      :error -> nil
    end

    render conn, session: session
  end

  def create(conn, %{"email" => email, "password" => password}) do
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

  defp valid_create_params?(params) do
    Map.has_key?(params, "email") && Map.has_key?(params, "password")
  end

  defp validate_create_params(conn, _) do
    cond do
      valid_create_params?(conn.params) -> conn
      true ->
        conn
        |> halt
        |> render("valid.json", session: nil)
    end
  end
end
