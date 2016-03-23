defmodule Finances.API.WalletControllerTest do
  use Finances.ConnCase

  alias Finances.Wallet
  @valid_attrs %{currency: "EUR", name: "Test wallet"}
  @invalid_attrs %{name: ""}

  setup do
    session = create_valid_session_for_test_user
    {:ok, [token: session.token]}
  end

  test "lists all entries on index", context do
    wallet = Wallet.changeset(
      %Wallet{}, %{
        name: "Test Wallet",
        currency: "EUR",
        user_id: Repo.get_by(Finances.Session, %{token: context[:token]}).user_id
    }) |> Repo.insert!

    %Wallet{ name: "Another Wallet", currency: "EUR", user_id: 2 } |> Repo.insert!

    conn = get conn(), "/api/wallets", token: context[:token]
    assert json_response(conn, 200) == %{"wallets" => [
          %{"name" => "Test Wallet", "currency" => "EUR", "id" => wallet.id}
        ]}
  end

  test "shows chosen resource", context do
    wallet = Repo.insert! %Wallet{name: "Test wallet", currency: "EUR"}
    conn = get conn, "/api/wallets/#{wallet.id}", token: context[:token]

    assert json_response(conn, 200)["wallet"] == %{
      "name" => wallet.name, "currency" => "EUR", "id" => wallet.id }
  end

  test "does not show resource and instead throw error when id is nonexistent", context do
    assert_error_sent 404, fn ->
      get conn, "/api/wallets/-1", token: context[:token]
    end
  end

  test "creates and renders resource when data is valid", context do
    conn = post conn, "/api/wallets", wallet: @valid_attrs, token: context[:token]
    body = json_response(conn, 201)

    assert body["wallet"]["id"]
    assert Repo.get_by(Wallet, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", context do
    conn = post conn, "/api/wallets", wallet: @invalid_attrs, token: context[:token]
    assert json_response(conn, 422)["errors"] != %{}
  end

  def create_wallet_for_test_user do
    user = Repo.all(User) |> List.last
    Repo.insert! %Wallet{name: "Any wallet", currency: "EUR", user_id: user.id}
  end

  test "updates and renders chosen resource when data is valid", context do
    wallet = create_wallet_for_test_user
    conn = put conn, "/api/wallets/#{wallet.id}", wallet: @valid_attrs, token: context[:token]
    assert json_response(conn, 200)["wallet"]["id"]
    assert Repo.get_by(Wallet, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", context do
    wallet = create_wallet_for_test_user
    conn = put conn, "/api/wallets/#{wallet.id}", wallet: @invalid_attrs, token: context[:token]
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", context do
    wallet = create_wallet_for_test_user
    conn = delete conn, "/api/wallets/#{wallet.id}", token: context[:token]
    assert response(conn, 204)
    refute Repo.get(Wallet, wallet.id)
  end
end
