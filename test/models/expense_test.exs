defmodule Finances.ExpenseTest do
  use Finances.ModelCase

  alias Finances.Expense

  @valid_attrs %{wallet_id: 1, category_id: 1, amount: 1, spent_at: "2016-04-10 10:00:00", notes: "Test"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Expense.changeset(%Expense{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Expense.changeset(%Expense{}, @invalid_attrs)
    refute changeset.valid?
  end
end
