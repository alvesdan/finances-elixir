defmodule Finances.WalletTest do
  use Finances.ModelCase

  alias Finances.Wallet

  @valid_attrs %{currency: "EUR", name: "Test wallet", user_id: 1}
  @invalid_attrs %{}
  @test_user create_test_user

  test "changeset with valid attributes" do
    changeset = Wallet.changeset(%Wallet{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Wallet.changeset(%Wallet{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "is able to insert a changeset with valid attributes" do
    changeset = Wallet.changeset(%Wallet{}, @valid_attrs)

    {:ok, wallet} = Finances.Repo.insert(changeset)
    assert wallet.name == "Test wallet"
  end

  test "is unable to insert a changeset with invalid attributes" do
    changeset = Wallet.changeset(%Wallet{}, @invalid_attrs)

    {:error, errored} = Finances.Repo.insert(changeset)
    assert errored.errors
  end
end
