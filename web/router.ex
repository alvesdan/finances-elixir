defmodule Finances.Router do
  use Finances.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    plug :assign_title, "Finances"
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Finances do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Finances do
  #   pipe_through :api
  # end

  defp assign_title(conn, title) do
    assign(conn, :title, title)
  end
end
