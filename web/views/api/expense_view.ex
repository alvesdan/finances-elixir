defmodule Finances.API.ExpenseView do
  use Finances.Web, :view

  def render("index.json", %{ expenses: expenses }) do
    %{expenses: expenses}
  end
end
