defmodule Finances.API.ExpenseController do
  use Finances.Web, :controller
  alias Finances.Expense
  import Finances.API.APIController

  plug :validate_wallet_owner

  def index(conn, params) do
    expenses = Expense.for_wallet(wallet(params["wallet_id"]))
    render conn, "index.json", expenses: expenses
  end
end
