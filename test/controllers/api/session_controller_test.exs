defmodule Finances.API.SessionControllerTest do
  use Finances.ConnCase
  alias Finances.Session

  @valid_token "fjlsfj2l34h2lh2l432lj"

  setup do
    %User{
      name: "Tester",
      email: "tester@example.com",
      password: "anything"
    } |> Repo.insert

    :ok
  end

  test "without valid session it returns false" do
    conn = get conn(), "/api/sessions/valid", format: "json"
    body = json_response(conn, 200) |> Poison.encode!

    assert Regex.match?(~r/"user":"invalid"/, body)
  end

  test "with a valid session it returns user basic info and session expiration time" do
    datetime = {{2015, 12, 31}, {12, 0, 0}}
    user = Repo.all(User) |> List.last
    Session.changeset(%Session{}, %{user_id: user.id, token: @valid_token, expires_at: datetime})
		|> Repo.insert!

    conn = get conn(), "api/sessions/valid", format: "json", token: @valid_token
    body = json_response(conn, 200)

    assert body.expires_at == datetime
    assert body.user_name == "Tester"
  end
end
