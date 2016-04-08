defmodule Finances.Repo.Migrations.CreateCategory do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :wallet_id, :integer
      add :name, :string

      timestamps
    end

  end
end
