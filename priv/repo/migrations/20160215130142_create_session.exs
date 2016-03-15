defmodule Finances.Repo.Migrations.CreateSession do
  use Ecto.Migration

  def change do
    create table(:sessions) do
      add :user_id, :integer
      add :token, :string
      add :expires_at, :datetime

      timestamps
    end

  end
end
