defmodule Finances.API.CategoryController do
  use Finances.Web, :controller
  alias Finances.Category

  def index(conn, params) do
    categories = Category.for_wallet(wallet(params["wallet_id"]))
    render(conn, "index.json", categories: categories)
  end

  def show(conn, %{"id" => id}) do
    category = Repo.get!(Category, id)
    render(conn, "show.json", category: category)
  end

  def create(conn, %{"category" => category_params, "wallet_id" => wallet_id}) do
    changeset = Category.changeset(%Category{}, %{
      name: category_params["name"],
      wallet_id: wallet_id
    })

    case Repo.insert(changeset) do
      {:ok, category} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", wallet_category_path(conn, :show, wallet_id, category))
        |> render("show.json", category: category)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Finances.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "category" => category_params, "wallet_id" => wallet_id}) do
    category = Repo.get_by!(Category, %{id: id, wallet_id: wallet_id})
    changeset = Category.changeset(category, category_params)

    case Repo.update(changeset) do
      {:ok, category} ->
        render(conn, "show.json", category: category)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Finances.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id, "wallet_id" => wallet_id}) do
    category = Repo.get_by!(Category, %{id: id, wallet_id: wallet_id})
    Repo.delete!(category)

    send_resp(conn, :no_content, "")
  end

  defp wallet(wallet_id) do
    Repo.get(Finances.Wallet, wallet_id)
  end
end
