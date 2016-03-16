defmodule Finances.API.SessionView do
  use Finances.Web, :view
  alias Finances.Repo
  alias Finances.Session

  def render("valid.json", %{ session: nil }) do
    %{session: "invalid"}
  end

  def render("valid.json", %{ session: session }) do
    cond do
      Session.valid?(session) ->
        %{session: session, user: Repo.preload(session, :user).user}
      true -> %{session: "invalid"}
    end
  end

  def render("create.json", %{ session: nil }) do
    %{session: "invalid"}
  end

  def render("create.json", %{ session: session }) do
    %{session: session, user: Repo.preload(session, :user).user}
  end
end
