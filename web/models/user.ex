defmodule Finances.User do
  use Finances.Web, :model

  @derive {Poison.Encoder, only: [:name, :email]}
  schema "users" do
    has_many :sessions, Finances.Session, on_delete: :delete_all
    has_many :wallets, Finances.Wallet, on_delete: :delete_all
    field :name, :string
    field :email, :string
    field :crypted_password, :string
    field :password, :string, virtual: true

    timestamps
  end

  @required_fields [:name, :email, :password]

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/\A[^@\s]+@([^@\s]+\.)+[^@\W]+\z/)
    |> validate_length(:password, min: 6)
  end
end
