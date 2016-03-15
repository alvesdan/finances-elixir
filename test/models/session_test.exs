defmodule Finances.SessionTest do
  use Finances.ModelCase

  alias Finances.Session

  @valid_attrs %{expires_at: "2010-04-17 14:00:00", token: "some content", user_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Session.changeset(%Session{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Session.changeset(%Session{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "it is able to insert a new session record" do
    changeset = Session.changeset(%Session{}, @valid_attrs)

    assert Finances.Repo.insert!(changeset)
  end
end
