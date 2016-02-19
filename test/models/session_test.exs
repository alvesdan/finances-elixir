defmodule Finances.SessionTest do
  use Finances.ModelCase

  alias Finances.Session

  @valid_datetime Ecto.DateTime.cast!("2020-10-10 12:00:00")

  @valid_attrs %{expires_at: @valid_datetime, token: "some content", user_id: "1"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Session.changeset(%Session{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Session.changeset(%Session{}, @invalid_attrs)
    refute changeset.valid?
  end
end
