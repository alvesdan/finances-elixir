defmodule Finances.API.SessionControllerTest do
  use Finances.ConnCase

  @valid_token "3c183a30cffcda1408daf1c61d47b274"
  @valid_datetime Ecto.DateTime.cast! {{2020, 12, 31}, {12, 0, 0}}
  @invalid_datetime Ecto.DateTime.cast! {{2015, 10, 10}, {12, 0, 0}}

  setup do
    %User{
      name: "Tester",
      email: "tester@example.com",
      password: "anything"
    } |> Repo.insert

    :ok
  end

  test "without valid session it returns invalid" do
    conn = get conn(), "/api/sessions/valid", format: "json"
    body = json_response(conn, 200) |> Poison.encode!

    assert Regex.match?(~r/"session":"invalid"/, body)
  end

  test "with a valid session it returns user basic info and session expiration time" do
    Repo.all(User) |> List.last
      |> Ecto.build_assoc(:sessions, token: @valid_token, expires_at: @valid_datetime)
      |> Repo.insert!

    conn = get conn(), "api/sessions/valid", format: "json", token: @valid_token
    body = json_response(conn, 200)

    session_datetime = Ecto.DateTime.cast! get_in(body, ["session", "expires_at"])
    assert session_datetime == @valid_datetime
    assert get_in(body, ["user", "name"]) == "Tester"
  end

  test "with an invalid session it returns invalid" do
    Repo.all(User) |> List.last
      |> Ecto.build_assoc(:sessions, token: @valid_token, expires_at: @invalid_datetime)
      |> Repo.insert!

    conn = get conn(), "api/sessions/valid", format: "json", token: @valid_token
    body = json_response(conn, 200) |> Poison.encode!

    assert Regex.match?(~r/"session":"invalid"/, body)
  end
end
