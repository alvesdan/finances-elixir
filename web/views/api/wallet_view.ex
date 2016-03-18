defmodule Finances.API.WalletView do
  use Finances.Web, :view

  def render("index.json", %{wallets: wallets}) do
    %{wallets: wallets}
  end

  def render("show.json", %{wallet: wallet}) do
    %{wallet: wallet}
  end
end
