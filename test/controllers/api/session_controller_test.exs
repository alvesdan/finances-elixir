defmodule Finances.API.SessionControllerTest do
  use Finances.ConnCase

  @valid_token "3f7c1d0e495a1b14f651fb5af568561c8e1a05ef5b71bdca30725c9b3d744332fecda309df455e4c20450dc9"
  @valid_datetime Ecto.DateTime.cast! {{2020, 12, 31}, {12, 0, 0}}
  @invalid_datetime Ecto.DateTime.cast! {{2015, 10, 10}, {12, 0, 0}}

  setup do
    user_params = %{name: "Tester", email: "tester@example.com", password: "123456"}
    changeset = User.changeset(%User{}, user_params)
    Finances.Registration.create(changeset, Repo)

    :ok
  end

  def create_session(datetime) do
    Repo.all(User) |> List.last
      |> Ecto.build_assoc(:sessions, token: @valid_token, expires_at: datetime)
      |> Repo.insert!
  end

  test "GET /valid without valid session it returns invalid" do
    conn = get conn(), "/api/sessions/valid", format: "json"
    body = json_response(conn, 200) |> Poison.encode!

    assert Regex.match?(~r/"session":"invalid"/, body)
  end

  test "GET /valid with a valid session it returns user basic info and session expiration time" do
    create_session(@valid_datetime)

    conn = get conn(), "api/sessions/valid", format: "json", token: @valid_token
    body = json_response(conn, 200)

    session_datetime = Ecto.DateTime.cast! get_in(body, ["session", "expires_at"])
    assert session_datetime == @valid_datetime
    assert get_in(body, ["user", "name"]) == "Tester"
  end

  test "GET /valid with an invalid session it returns invalid" do
    create_session(@invalid_datetime)

    conn = get conn(), "api/sessions/valid", format: "json", token: @valid_token
    body = json_response(conn, 200) |> Poison.encode!

    assert Regex.match?(~r/"session":"invalid"/, body)
  end

  test "POST /create with invalid credentials" do
    conn = post conn(), "api/sessions/create", format: "json", email: "tester@example.com", password: "wrong"
    body = json_response(conn, 200) |> Poison.encode!

    assert Regex.match?(~r/"session":"invalid"/, body)
  end

  test "POST /create with valid credentials" do
    conn = post conn(), "api/sessions/create", format: "json", email: "tester@example.com", password: "123456"
    body = json_response(conn, 201)

    assert get_in(body, ["user", "name"]) == "Tester"
    session_datetime = Ecto.DateTime.cast! get_in(body, ["session", "expires_at"])
    now = Ecto.DateTime.from_erl(:calendar.local_time)
    assert Ecto.DateTime.compare(now, session_datetime) == :lt
  end
end
