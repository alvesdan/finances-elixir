defmodule Finances.RegistrationTest do
  use Finances.ModelCase
  alias Finances.User
  alias Finances.Registration

  @user_params %{name: "Tester", email: "tester@example.com", password: "123456"}
  @valid_changeset User.changeset(%User{}, @user_params)

  test "#valid? with a valid username and password returns true" do
    Registration.create(@valid_changeset, Repo)

    assert Registration.valid?("tester@example.com", "123456")
  end

  test "#valid? with and invalid username and password returns false" do
    Registration.create(@valid_changeset, Repo)

    refute Registration.valid?("tester@example.com", "abcdef")
  end

  test "#valid? witn an invalid email returns false" do
    Registration.create(@valid_changeset, Repo)

    refute Registration.valid?("tester.another@example.com", "123456")
  end
end
