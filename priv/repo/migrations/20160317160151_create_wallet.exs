defmodule Finances.Repo.Migrations.CreateWallet do
  use Ecto.Migration

  def change do
    create table(:wallets) do
      add :user_id, :integer
      add :name, :string
      add :currency, :string

      timestamps
    end

    create index(:wallets, [:user_id, :name], unique: true)
  end
end
