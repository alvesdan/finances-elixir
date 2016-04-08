defmodule Finances.API.APIController do
  alias Finances.Repo
  import Plug.Conn
  import Phoenix.Controller

  def wallet(wallet_id) do
    Repo.get(Finances.Wallet, wallet_id)
  end

  def validate_wallet_owner(conn,
    %{user_id: user_id, wallet_user_id: wallet_user_id}) do

    case user_id do
      ^wallet_user_id -> conn
      _ ->
        conn
        |> halt
        |> put_status(:unauthorized)
        |> render(Finances.ErrorView, "401.json")
    end
  end

  def validate_wallet_owner(conn, _params) do
    case Map.fetch(conn.params, "wallet_id") do
      {:ok, wallet_id} ->
        validate_wallet_owner(conn, %{
          user_id: conn.assigns.current_user.id,
          wallet_user_id: wallet(wallet_id).user_id
        })

      _ ->
        conn
        |> halt
        |> put_status(:not_found)
        |> render(Finances.ErrorView, "400.json")
    end
  end
end
