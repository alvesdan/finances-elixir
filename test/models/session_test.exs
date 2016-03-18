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

  test "#create_for with user returns a new valid session" do
    user = create_test_user
    {:ok, session} = Session.create_for(user)

    assert session.expires_at != nil
    assert Repo.preload(session, :user).user.email == user.email
  end

  test "#find_or_create_for with a valid session returns the existing one" do
    user = create_test_user
    {:ok, session} = Session.create_for(user)

    assert Session.find_or_create_for(user) == {:ok, session}
  end
end
