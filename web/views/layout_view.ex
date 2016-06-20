defmodule Finances.LayoutView do
  use Finances.Web, :view

  def site_title do
    "Finances"
  end

  def body_class(conn) do
    conn.private[:body_class] || ""
  end
end
