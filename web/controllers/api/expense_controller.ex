defmodule Finances.API.ExpenseController do
  use Finances.Web, :controller
  alias Finances.Expense
  import Finances.API.APIController

  plug :validate_wallet_owner

  def index(conn, params) do
    expenses = Expense.for_wallet(wallet(params["wallet_id"]))
    render conn, "index.json", expenses: expenses
  end

  def create(conn, %{"expense" => expense_params, "wallet_id" => wallet_id}) do
    changeset = Expense.changeset(%Expense{}, %{
      name: expense_params["name"],
      amount: expense_params["amount"],
      spent_at: expense_params["spent_at"],
      notes: expense_params["notes"],
      wallet_id: wallet_id,
      category_id: expense_params["category_id"],
    })

    case Repo.insert(changeset) do
      {:ok, expense} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", wallet_expense_path(conn, :index, wallet_id))
        |> render("show.json", expense: expense)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Finances.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "expense" => expense_params, "wallet_id" => wallet_id}) do
    expense = Repo.get_by!(Expense, %{id: id, wallet_id: wallet_id})
    changeset = Expense.changeset(expense, expense_params)

    case Repo.update(changeset) do
      {:ok, expense} ->
        render(conn, "show.json", expense: expense)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Finances.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id, "wallet_id" => wallet_id}) do
    expense = Repo.get_by!(Expense, %{id: id, wallet_id: wallet_id})
    Repo.delete!(expense)

    send_resp(conn, :no_content, "")
  end
end
