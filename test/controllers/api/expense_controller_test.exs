defmodule ExpenseControllerTest do
  use Finances.ConnCase
  alias Finances.{Wallet, Category, Expense}

  setup do
    session = create_valid_session_for_test_user
    wallet = Wallet.changeset(
      %Wallet{}, %{
        name: "Test Wallet",
        currency: "EUR",
        user_id: session.user_id
    }) |> Repo.insert!

    category = Category.changeset(
      %Category{}, %{
        name: "Test Category",
        wallet_id: wallet.id
    }) |> Repo.insert!

    {:ok, [token: session.token, wallet: wallet, category: category]}
  end

  def create_test_expense(wallet, category) do
    Expense.changeset(
      %Expense{}, %{
        wallet_id: wallet.id,
        category_id: category.id,
        amount: 10.5,
        spent_at: "2016-04-17 14:00:00",
        notes: "Test Expense"
    }) |> Repo.insert!
  end

  test "lists all entries on index", context do
    expense = create_test_expense context[:wallet], context[:category]

    wallet_id = context[:wallet].id
    conn = get conn(), "/api/wallets/#{wallet_id}/expenses", token: context[:token]
    assert json_response(conn, 200) == %{"expenses" => [%{
      "id" => expense.id,
      "amount" => "10.5",
      "spent_at" => "2016-04-17T14:00:00Z",
      "notes" => "Test Expense"
    }]}
  end
end
