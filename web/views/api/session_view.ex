defmodule Finances.API.SessionView do
  use Finances.Web, :view

  def render("valid.json", %{ user: user }) do
    %{ user: "invalid" }
  end
end
