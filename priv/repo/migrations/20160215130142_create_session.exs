defmodule Finances.Repo.Migrations.CreateSession do
  use Ecto.Migration

  def change do
    create table(:sessions) do
      add :user_id, :string
      add :token, :binary
      add :expires_at, :datetime

      timestamps
    end

  end
end
