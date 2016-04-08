defmodule GenericTestHelper do
  alias Finances.{Repo, User, Registration, Session}

  def create_test_user(email \\ "tester@example.com") do
    user_params = %{
      name: "Tester",
      email: email,
      password: "123456"
    }
    changeset = User.changeset(%User{}, user_params)

    case Registration.create(changeset, Repo) do
      {:ok, user} -> user
      _ -> raise "Error creating test user"
    end
  end

  def create_valid_session_for_test_user do
    user = create_test_user
    create_valid_session_for(user)
  end

  def create_valid_session_for(user) do
    case Session.find_or_create_for(user) do
      {:ok, session} -> session
      {:error, _} -> raise "Error creating test session"
    end
  end
end
