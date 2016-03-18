defmodule Finances.API.WalletController do
  use Finances.Web, :controller

  alias Finances.Wallet

  plug :scrub_params, "wallet" when action in [:create, :update]

  def index(conn, _params) do
    wallets = Repo.all(Wallet)
    render(conn, "index.json", wallets: wallets)
  end

  def create(conn, %{"wallet" => wallet_params}) do
    changeset = Wallet.changeset(%Wallet{}, %{
      name: wallet_params["name"],
      currency: wallet_params["currency"],
      user_id: conn.assigns[:current_user].id
    })

    case Repo.insert(changeset) do
      {:ok, wallet} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", wallet_path(conn, :show, wallet))
        |> render("show.json", wallet: wallet)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Finances.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    wallet = Repo.get!(Wallet, id)
    render(conn, "show.json", wallet: wallet)
  end

  def update(conn, %{"id" => id, "wallet" => wallet_params}) do
    wallet = Repo.get_by!(Wallet, %{id: id, user_id: conn.assigns[:current_user].id})
    changeset = Wallet.changeset(wallet, wallet_params)

    case Repo.update(changeset) do
      {:ok, wallet} ->
        render(conn, "show.json", wallet: wallet)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Finances.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    wallet = Repo.get_by!(Wallet, %{id: id, user_id: conn.assigns[:current_user].id})
    Repo.delete!(wallet)

    send_resp(conn, :no_content, "")
  end
end
