defmodule Finances.API.ExpenseView do
  use Finances.Web, :view

  def render("index.json", %{ expenses: expenses }) do
    %{expenses: expenses}
  end

  def render("show.json", %{ expense: expense }) do
    %{expense: expense}
  end
end
