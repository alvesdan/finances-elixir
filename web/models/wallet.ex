defmodule Finances.Wallet do
  use Finances.Web, :model
  import Ecto.Query

  @derive {Poison.Encoder, only: [:id, :name, :currency]}
  schema "wallets" do
    belongs_to :user, Finances.User
    field :name, :string
    field :currency, :string

    timestamps
  end

  @required_fields ~w(name currency user_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:name, name: :wallets_user_id_name_index)
    |> validate_length(:name, min: 2)
  end

  def for_user(user) do
    __MODULE__ |> where(user_id: ^user.id) |> Finances.Repo.all
  end
end
