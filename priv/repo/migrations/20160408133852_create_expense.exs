defmodule Finances.Repo.Migrations.CreateExpense do
  use Ecto.Migration

  def change do
    create table(:expenses) do
      add :wallet_id, :integer
      add :category_id, :integer
      add :amount, :decimal
      add :spent_at, :datetime
      add :notes, :string
      timestamps
    end

  end
end
