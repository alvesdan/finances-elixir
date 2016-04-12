defmodule Finances.ExpenseTest do
  use Finances.ModelCase

  alias Finances.Expense

  @valid_attrs %{}
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
