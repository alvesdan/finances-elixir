defmodule ExpenseControllerTest do
  use Finances.ConnCase
  alias Finances.{Wallet, Category, Expense}

  @valid_attrs %{amount: 5, spent_at: "2016-04-17 14:00:00"}

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
    conn = get build_conn(), "/api/wallets/#{wallet_id}/expenses", token: context[:token]
    assert json_response(conn, 200) == %{"expenses" => [%{
      "id" => expense.id,
      "amount" => "10.5",
      "spent_at" => "2016-04-17T14:00:00",
      "notes" => "Test Expense",
      "category_id" => context[:category].id
    }]}
  end

  test "creates and renders resource when data is valid", context do
    wallet_id = context[:wallet].id
    category_id = context[:category].id
    conn = post(build_conn, "/api/wallets/#{wallet_id}/expenses",
      expense: Map.put(@valid_attrs, :category_id, category_id), token: context[:token])
    body = json_response(conn, 201)

    assert body["expense"]["id"]
    assert Repo.get_by(Expense, @valid_attrs)
  end

  test "updates and renders chosen resource when data is valid", context do
    wallet_id = context[:wallet].id
    expense = create_test_expense context[:wallet], context[:category]

    conn = put build_conn, "/api/wallets/#{wallet_id}/expenses/#{expense.id}",
      expense: %{notes: "Updated expense"}, token: context[:token]
    body = json_response(conn, 200)

    assert body["expense"]["id"]
    assert Repo.get_by(Expense, %{notes: "Updated expense"})
  end

  test "deletes chosen resource", context do
    wallet_id = context[:wallet].id
    expense = create_test_expense context[:wallet], context[:category]
    conn = delete build_conn, "/api/wallets/#{wallet_id}/expenses/#{expense.id}", token: context[:token]
    assert response(conn, 204)
    refute Repo.get(Expense, expense.id)
  end
end
