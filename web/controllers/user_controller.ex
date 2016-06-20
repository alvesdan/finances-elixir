defmodule Finances.UserController do
  use Finances.Web, :controller
  alias Finances.User
  import Finances.HTMLController

  plug :scrub_params, "user" when action in [:create, :update]
  plug :add_body_class, "user"

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Finances.Registration.create(changeset, Repo) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :new))
      {:error, changeset} ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end
end
