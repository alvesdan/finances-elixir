defmodule Finances.Plugs.Authenticate do
  import Plug.Conn
  import Phoenix.Controller

  alias Finances.{Repo, Session}

  def init(default), do: default

  def call(conn, _) do
    case get_session_for(conn) do
      {:ok, session} ->
        conn
        |> assign(:current_user, Repo.preload(session, :user).user)
      {:error, _message} ->
        conn
        |> halt
        |> render(Finances.ErrorView, "401.json")
    end
  end

  defp get_session_for(conn) do
    case Map.fetch(conn.params, "token") do
      {:ok, token} ->
        case Repo.get_by(Session, %{token: token}) do
          nil -> {:error, "Session not found"}
          session ->
            if Session.valid?(session), do: {:ok, session}, else: {:error, "Invalid session"}
        end

      _ -> {:error, "Token not provided"}
    end
  end
end
