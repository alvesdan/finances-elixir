defmodule Finances.API.UserControllerTest do
  use Finances.ConnCase

  setup do
    %User{
      name: "Tester",
      email: "tester@example.com",
      password: "anything"
    } |> Repo.insert

    :ok
  end

  test "/index returns a list of users" do
    conn = get conn(), "/api/users"
    expected_json = Repo.all(User) |> Poison.encode!

    body = json_response(conn, 200)
    assert body == expected_json
  end
end
