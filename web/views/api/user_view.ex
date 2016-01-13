defmodule Finances.API.UserView do
  use Finances.Web, :view

  def render("index.json", %{ users: users }) do
    users
  end
end
