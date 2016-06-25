defmodule Finances.API.CategoryControllerTest do
  use Finances.ConnCase
  alias Finances.{Wallet, Category}

  @valid_attrs %{name: "Test Category"}
  @invalid_attrs %{name: ""}

  setup do
    session = create_valid_session_for_test_user
    wallet = Wallet.changeset(
      %Wallet{}, %{
        name: "Test Wallet",
        currency: "EUR",
        user_id: session.user_id
    }) |> Repo.insert!

    {:ok, [token: session.token, wallet: wallet]}
  end

  def test_category(wallet) do
    Category.changeset(
      %Category{}, %{
        name: "Test Category",
        wallet_id: wallet.id
    }) |> Repo.insert!
  end

  test "lists all entries on index", context do
    wallet_id = context[:wallet].id
    conn = get build_conn(), "/api/wallets/#{wallet_id}/categories", token: context[:token]
    assert json_response(conn, 200) == %{"categories" => []}
  end

  test "shows chosen resource", context do
    category = test_category(context[:wallet])
    conn = get build_conn(), "/api/wallets/#{category.wallet_id}/categories/#{category.id}", token: context[:token]

    assert json_response(conn, 200)["category"] == %{ "name" => category.name, "id" => category.id }
  end

  test "does not show resource and instead throw error when id is nonexistent", context do
    assert_error_sent 404, fn ->
      get build_conn, "/api/wallets/#{context[:wallet].id}/categories/-1", token: context[:token]
    end
  end

  test "creates and renders resource when data is valid", context do
    wallet_id = context[:wallet].id
    conn = post build_conn, "/api/wallets/#{wallet_id}/categories", category: @valid_attrs, token: context[:token]
    body = json_response(conn, 201)

    assert body["category"]["id"]
    assert Repo.get_by(Category, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", context do
    wallet_id = context[:wallet].id
    conn = post build_conn, "/api/wallets/#{wallet_id}/categories", category: @invalid_attrs, token: context[:token]
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", context do
    wallet_id = context[:wallet].id
    category = test_category(context[:wallet])
    conn = put build_conn, "/api/wallets/#{wallet_id}/categories/#{category.id}", category: @valid_attrs, token: context[:token]
    assert json_response(conn, 200)["category"]["id"]
    assert Repo.get_by(Category, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", context do
    wallet_id = context[:wallet].id
    category = test_category(context[:wallet])
    conn = put build_conn, "/api/wallets/#{wallet_id}/categories/#{category.id}", category: @invalid_attrs, token: context[:token]
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", context do
    wallet_id = context[:wallet].id
    category = test_category(context[:wallet])
    conn = delete build_conn, "/api/wallets/#{wallet_id}/categories/#{category.id}", token: context[:token]
    assert response(conn, 204)
    refute Repo.get(Category, category.id)
  end

  test "it validates wallet ownership", context do
    other_user = create_test_user("another@example.com")
    other_wallet = Wallet.changeset(
      %Wallet{}, %{
        name: "Test Wallet",
        currency: "EUR",
        user_id: other_user.id
    }) |> Repo.insert!
    category = test_category(other_wallet)

    conn = delete build_conn, "/api/wallets/#{other_wallet.id}/categories/#{category.id}", token: context[:token]
    assert response(conn, 401)
    assert Repo.get(Category, category.id)
  end
end
