defmodule Finances.Category do
  use Finances.Web, :model
  import Ecto.Query

  @derive {Poison.Encoder, only: [:id, :name]}
  schema "categories" do
    belongs_to :wallet, Finances.Wallet
    field :name, :string

    timestamps
  end

  @required_fields ~w(wallet_id name)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:name, min: 2)
  end

  def for_wallet(%Finances.Wallet{id: wallet_id}) do
    __MODULE__ |> where(wallet_id: ^wallet_id) |> Finances.Repo.all
  end
end
