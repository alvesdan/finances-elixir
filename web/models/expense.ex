defmodule Finances.Expense do
  use Finances.Web, :model
  import Ecto.Query

  @derive {Poison.Encoder, only: [:id, :amount, :spent_at, :notes]}
  schema "expenses" do
    belongs_to :wallet, Finances.Wallet
    belongs_to :category, Finances.Category
    field :amount, :decimal
    field :spent_at, Ecto.DateTime
    field :notes, :string
    timestamps
  end

  @required_fields ~w(wallet_id category_id amount spent_at notes)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def for_wallet(%Finances.Wallet{id: wallet_id}) do
    __MODULE__ |> where(wallet_id: ^wallet_id) |> Finances.Repo.all
  end
end
