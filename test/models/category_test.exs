defmodule Finances.CategoryTest do
  use Finances.ModelCase

  alias Finances.Category

  @valid_attrs %{name: "some content", wallet_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Category.changeset(%Category{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Category.changeset(%Category{}, @invalid_attrs)
    refute changeset.valid?
  end
end
